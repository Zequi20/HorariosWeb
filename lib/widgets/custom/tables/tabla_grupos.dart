import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/modals/viaje/modal_agregar_viaje.dart';
import 'package:horarios_web/widgets/modals/viaje/modal_editar_viaje.dart';
import 'package:http/http.dart' as http;

class GroupTable extends StatefulWidget {
  const GroupTable({
    Key? key,
    required this.travels,
    required this.index,
    required this.updateParent,
    required this.fecha,
  }) : super(key: key);
  final List<Group> travels;
  final int index;
  final String fecha;
  final VoidCallback updateParent;
  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  ScrollController horizontalScroll = ScrollController();
  ScrollController verticalScroll = ScrollController();
  //colores
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var colorBlanco = Colors.white;
  List<int> selectedIndex = [];
  @override
  Widget build(BuildContext context) {
    List travelsRows = widget.travels[widget.index].travelsData;
    List<DataRow> rows = travelsRows
        .map((e) => DataRow(
                selected: selectedIndex.contains(travelsRows.indexOf(e)),
                onSelectChanged: (value) {
                  if (!value!) {
                    selectedIndex.remove(travelsRows.indexOf(e));
                  } else {
                    selectedIndex.add(travelsRows.indexOf(e));
                  }
                  setState(() {});
                },
                cells: [
                  DataCell(Text(e['ID'].toString())),
                  DataCell(Text(e['DEPARTURE_TIME'].toString().split('.')[0])),
                  DataCell(Text(e['ARRIVAL_TIME'].toString().split('.')[0])),
                  DataCell(Text(
                    e['VEHICLE'].toString(),
                    key: Key(e['VEHICLE_ID'].toString()),
                  )),
                  DataCell(Text(
                    e['DRIVER1'],
                    key: Key(e['DRIVER1_ID'].toString()),
                  )),
                  DataCell(Text(
                    e['DRIVER2'],
                    key: Key(e['DRIVER2_ID'].toString()),
                  )),
                  DataCell(Text(e['NOTE'])),
                ]))
        .toList();
    return ExcludeFocus(
      child: Table(
        children: [
          TableRow(children: [
            DataTable(
                decoration: BoxDecoration(color: colorBlanco),
                onSelectAll: (value) {
                  if (value!) {
                    selectedIndex.addAll(travelsRows
                        .map((e) => travelsRows.indexOf(e))
                        .toList());
                  } else {
                    selectedIndex.clear();
                  }
                  setState(() {});
                },
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('PARTIDA')),
                  DataColumn(label: Text('LLEGADA')),
                  DataColumn(label: Text('COCHE')),
                  DataColumn(label: Text('CONDUCTOR')),
                  DataColumn(label: Text('GUARDA')),
                  DataColumn(label: Text('NOTA')),
                ],
                rows: widget.travels[widget.index].travelsData.isNotEmpty
                    ? rows
                    : []),
          ]),
          TableRow(children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      focusColor: resaltadoColor,
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return ModalAgregarViaje(
                                grupoId: widget.travels[widget.index].id,
                                fecha: widget.fecha,
                              );
                            });
                        widget.updateParent();
                      },
                      icon: Icon(
                        Icons.add,
                        color: colorBlanco,
                      )),
                  IconButton(
                      focusColor: resaltadoColor,
                      onPressed: () async {
                        if (selectedIndex.isNotEmpty &&
                            selectedIndex.length < 2) {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return ModalEditarViaje(
                                  grupoId: widget.travels[widget.index].id,
                                  seleccion: rows[selectedIndex.first],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title:
                                        const Text('Seleccion unica requerida'),
                                    content: Wrap(
                                      children: [
                                        Text(selectedIndex.isEmpty
                                            ? 'Usted no ha seleccionado ningun elemento'
                                            : 'Seleccione un unico elemento')
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: const ButtonStyle(
                                            foregroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.white)),
                                        child: const Text('Aceptar'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ]);
                              });
                        }

                        selectedIndex.clear();

                        widget.updateParent();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: colorBlanco,
                      )),
                  IconButton(
                      focusColor: resaltadoColor,
                      onPressed: () async {
                        if (selectedIndex.isNotEmpty) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Eliminar registro'),
                                content: Wrap(
                                  children: [
                                    Text(
                                        'Seguro que desea eliminar ${selectedIndex.length} ${selectedIndex.length > 1 ? 'registros' : 'registro'}?')
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Si, continuar'),
                                    onPressed: () {
                                      deleteReg(rows);
                                    },
                                  ),
                                  TextButton(
                                    style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Seleccionar registro(s)'),
                                content: Wrap(
                                  children: const [
                                    Text(
                                        'Para borrar un registro debe seleccionarlo de la lista')
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    style: const ButtonStyle(
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        widget.updateParent();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: colorBlanco,
                      ))
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }

  String formatId(List<int> lista, List<DataRow> rows) {
    return lista
        .map((e) => (rows[e].cells[0].child as Text).data)
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
  }

  void deleteReg(List<DataRow> rows) async {
    var requestPost = http.Request(
        'DELETE', Uri.parse('http://190.52.165.206:3000/delete_travels'));

    String idList = formatId(selectedIndex, rows);

    requestPost.bodyFields = {'id': idList};
    http.StreamedResponse responseStream = await requestPost.send();

    if (responseStream.statusCode == 200) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Operacion exitosa'),
                content: const Text('Operacion realizada con exito :)'),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                      setState(() {
                        selectedIndex.clear();
                      });
                    },
                  ),
                ],
              );
            });
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Operacion fallida'),
                content: const Text('Algo ha salido mal :('),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
      }
    }
  }
}
