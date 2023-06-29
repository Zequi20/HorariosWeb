import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_campos_vehiculos.dart';
import 'package:horarios_web/widgets/modals/coche/modal_agregar_vehiculo.dart';
import 'package:horarios_web/widgets/modals/coche/modal_editar_vehiculo.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenVehiculos extends StatefulWidget {
  const ScreenVehiculos({super.key, this.userId = 0});
  final int? userId;

  @override
  State<ScreenVehiculos> createState() => _ScreenVehiculosState();
}

class _ScreenVehiculosState extends State<ScreenVehiculos>
    with AutomaticKeepAliveClientMixin {
  final verticalController = ScrollController();
  final horizontalController = ScrollController();

  DateTime curDate = DateTime.now();
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];

  FocusNode foco = FocusNode();
  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();
  StreamController vehiController = StreamController<List<DataRow>>();

  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  int searchIndex = 0;
  List<int> selectedRows = [];

  List<DropdownMenuItem<int>> itemList = const [
    DropdownMenuItem(
      value: 0,
      child: Text('Id', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Nro', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('Tipo', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('Descripcion', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('Matricula', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 5,
      child: Text('Asientos', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 6,
      child: Text('Usuario', overflow: TextOverflow.ellipsis),
    )
  ];
  @override
  void initState() {
    super.initState();
    foco.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatId(List<int> lista) {
    return lista
        .map((e) => (rows[e].cells[0].child as Text).data)
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
  }

  void deleteReg() async {
    var requestPost = http.Request(
        'DELETE', Uri.parse('http://190.52.165.206:3000/delete_vehicles'));

    String idList = formatId(selectedRows);

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
                        selectedRows.clear();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: gradPrincipalColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 55,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIconColor: Colors.black54,
                              hintText: 'Filtrar',
                              suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 55,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        isExpanded: true,
                        focusColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        menuMaxHeight: 256,
                        value: searchIndex,
                        items: itemList,
                        onChanged: (int? value) {
                          searchIndex = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  CallbackShortcuts(
                    key: GlobalKey(),
                    bindings: <ShortcutActivator, VoidCallback>{
                      const SingleActivator(LogicalKeyboardKey.keyA): () {
                        onAdd();
                      },
                      const SingleActivator(LogicalKeyboardKey.keyE): () {
                        onEdit();
                      },
                      const SingleActivator(LogicalKeyboardKey.keyR): () {
                        onDelete();
                      },
                    },
                    child: Focus(
                      focusNode: foco,
                      child: PopupMenuButton(
                          position: PopupMenuPosition.under,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: resaltadoColor)),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          splashRadius: 18,
                          icon: Icon(
                            Icons.construction,
                            fill: 1,
                            color: resaltadoColor,
                          ),
                          iconSize: 32,
                          tooltip: 'Acciones',
                          itemBuilder: (BuildContext context) {
                            return [
                              TextButton.icon(
                                label: Text(
                                  'Agregar (a)',
                                  style: TextStyle(color: principalColor),
                                ),
                                onPressed: onAdd,
                                icon: Icon(
                                  Icons.add,
                                  color: gradPrincipalColor,
                                  size: 30,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: onEdit,
                                icon: Icon(
                                  Icons.edit,
                                  color: gradPrincipalColor,
                                ),
                                label: Text(
                                  'Editar (e)',
                                  style: TextStyle(color: principalColor),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: onDelete,
                                icon: Icon(
                                  Icons.delete,
                                  color: gradPrincipalColor,
                                ),
                                label: Text(
                                  'Remover (r)',
                                  style: TextStyle(color: principalColor),
                                ),
                              )
                            ].map((e) => PopupMenuItem(child: e)).toList();
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: fetchRows(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (searchController.text.trim().isEmpty) {
                  rows = snapshot.data!;
                } else {
                  rows = snapshot.data!.where((row) {
                    String rowText = (row.cells[searchIndex].child as Text)
                        .data!
                        .toLowerCase();
                    String searchTerm = searchController.text.toLowerCase();
                    return rowText.contains(searchTerm);
                  }).toList();
                }
                return Expanded(
                  child: SingleChildScrollView(
                    controller: verticalController,
                    scrollDirection: Axis.vertical,
                    child: Table(children: [
                      TableRow(children: [
                        DataTable(
                            onSelectAll: (value) {
                              setState(() {
                                if (value!) {
                                  selectedRows
                                      .addAll(rows.map((e) => rows.indexOf(e)));
                                } else {
                                  selectedRows.clear();
                                }
                              });
                            },
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Nro')),
                              DataColumn(label: Text('Tipo')),
                              DataColumn(label: Text('Descripcion')),
                              DataColumn(label: Text('Matricula')),
                              DataColumn(label: Text('Asientos')),
                              DataColumn(label: Text('Usuario')),
                            ],
                            rows: rows),
                      ]),
                    ]),
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<DataRow>> fetchRows() async {
    List<DataRow> fetchedRows = [];
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    var request =
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/VEHICLES'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);
    for (var i = 0; i < jsonResponse.length; i++) {
      fetchedRows.add(DataRow(
          selected: selectedRows.contains(i),
          onSelectChanged: (value) {
            if (value!) {
              selectedRows.add(i);
            } else {
              selectedRows.remove(i);
            }
            setState(() {});
          },
          cells: [
            DataCell(Text(jsonResponse[i]['ID'].toString())),
            DataCell(Text(jsonResponse[i]['NUMBER'].toString())),
            DataCell(Text(jsonResponse[i]['TYPE'].toString())),
            DataCell(Text(jsonResponse[i]['DESCRIPTION'])),
            DataCell(Text(jsonResponse[i]['LICENSE_PLATE'].toString().trim())),
            DataCell(Text(jsonResponse[i]['SEATS'].toString().trim())),
            DataCell(Text(jsonResponse[i]['NAME'].toString().split('T')[0])),
          ]));
    }

    return fetchedRows;
  }

//{"ID","TYPE","NAME","CI","DRIVING_LICENSE","BIRTH_DATE","MARITAL_STATUS","ADDRESS","PHONE","USUARIO","DISCHARGE_DATE""}
  @override
  bool get wantKeepAlive => false;

  void onAdd() async {
    await showDialog(
        context: context,
        builder: (context) {
          return ModalAgregarVehiculo(
            userId: widget.userId,
          );
        });
    setState(() {
      fetchRows();
    });
  }

  void onEdit() async {
    if (selectedRows.isNotEmpty && selectedRows.length < 2) {
      CamposVehiculos campos =
          CamposVehiculos.fromRow(rows, selectedRows.first);
      await showDialog(
          context: context,
          builder: (context) {
            return ModalEditarVehiculo(
              asientosController: campos.asientosController,
              descripcionController: campos.descripcionController,
              matriculaController: campos.matriculaController,
              nroController: campos.nroController,
              rowId: campos.rowId,
              tipoController: campos.tipoController,
            );
          });
      setState(() {
        selectedRows.clear();
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: const Text('Seleccion unica requerida'),
                content: Wrap(
                  children: [
                    Text(selectedRows.isEmpty
                        ? 'Usted no ha seleeccionado ningun elemento'
                        : 'Seleccione un unico elemento')
                  ],
                ),
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
                ]);
          });
    }
  }

  void onDelete() {
    if (selectedRows.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Eliminar registro'),
            content: Wrap(
              children: [
                Text(
                    'Seguro que desea eliminar ${selectedRows.length} ${selectedRows.length > 1 ? 'registros' : 'registro'}?')
              ],
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Si, continuar'),
                onPressed: () {
                  deleteReg();
                },
              ),
              TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
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
                Text('Para borrar un registro debe seleccionarlo de la lista')
              ],
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
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
  }
}
