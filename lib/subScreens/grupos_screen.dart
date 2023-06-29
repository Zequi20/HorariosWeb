import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_campos_grupos.dart';
import 'package:horarios_web/widgets/modals/grupo/modal_agregar_grupo.dart';
import 'package:horarios_web/widgets/modals/grupo/modal_editar_grupo.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenGrupos extends StatefulWidget {
  const ScreenGrupos({super.key, this.userId = 0});
  final int? userId;
  @override
  State<ScreenGrupos> createState() => _ScreenGruposState();
}

class _ScreenGruposState extends State<ScreenGrupos>
    with AutomaticKeepAliveClientMixin {
  final verticalController = ScrollController();
  final horizontalController = ScrollController();
  List<int> idList = [];
  DateTime curDate = DateTime.now();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];
  List<DataRow> fetchedRows = [];
  List<int> selectedRows = [];
  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();
  FocusNode foco = FocusNode();
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
        'DELETE', Uri.parse('http://190.52.165.206:3000/delete_groups'));

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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIconColor: Colors.black54,
                              hintText: 'Buscar',
                              prefixIcon: Icon(Icons.search)),
                        ),
                      )),
                  CallbackShortcuts(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          position: PopupMenuPosition.under,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: resaltadoColor)),
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
                                  style: TextStyle(color: gradPrincipalColor),
                                ),
                                onPressed: onAdd,
                                icon: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: gradPrincipalColor,
                                ),
                              ),
                              TextButton.icon(
                                label: Text('Editar (e)',
                                    style:
                                        TextStyle(color: gradPrincipalColor)),
                                onPressed: onEdit,
                                icon: Icon(
                                  Icons.edit,
                                  color: gradPrincipalColor,
                                ),
                              ),
                              TextButton.icon(
                                label: Text('Remover (r)',
                                    style:
                                        TextStyle(color: gradPrincipalColor)),
                                onPressed: onDelete,
                                icon: Icon(
                                  Icons.delete,
                                  color: gradPrincipalColor,
                                ),
                              )
                            ].map((e) {
                              return PopupMenuItem(
                                child: e,
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: horizontalController,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 14,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                  future: fetchRows(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (searchController.text.trim().isEmpty) {
                        rows = snapshot.data!;
                      } else {
                        rows = snapshot.data!.where((row) {
                          String rowText = row.cells
                              .map((cell) => (cell.child as Text).data)
                              .join()
                              .toLowerCase();
                          String searchTerm =
                              searchController.text.toLowerCase();
                          return rowText.contains(searchTerm);
                        }).toList();
                      }
                      return SingleChildScrollView(
                        controller: verticalController,
                        scrollDirection: Axis.vertical,
                        child: DataTable(
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
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Compania')),
                              DataColumn(label: Text('Descripcion')),
                              DataColumn(label: Text('Usuario')),
                              DataColumn(label: Text('Km')),
                            ],
                            rows: rows),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      ));
                    }
                  },
                ),
              ),
            ),
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
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/GROUPS'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);
    for (var i = 0; i < jsonResponse.length; i++) {
      idList.add(jsonResponse[i]['ID']);
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
            DataCell(Text(jsonResponse[i]['NAME'].toString())),
            DataCell(Text(
              jsonResponse[i]['COMPANY'].toString(),
              key: Key(jsonResponse[i]['COMPANYID'].toString()),
            )),
            DataCell(Text(jsonResponse[i]['DESCRIPTION'])),
            DataCell(Text(jsonResponse[i]['USERNAME'].toString().trim())),
            DataCell(Text(jsonResponse[i]['KM'].toString().trim())),
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
          return ModalAgregarGrupo(
            userId: widget.userId,
          );
        });
    setState(() {
      fetchRows();
    });
  }

  void onEdit() async {
    if (selectedRows.isNotEmpty && selectedRows.length < 2) {
      CamposGrupos campos = CamposGrupos.fromRow(rows, selectedRows.first);
      await showDialog(
          context: context,
          builder: (context) {
            return ModalEditarGrupo(
              id: campos.rowId,
              nombreController: campos.nombre,
              empresa: campos.empresa,
              descripcionController: campos.descripcion,
              kmController: campos.km,
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
