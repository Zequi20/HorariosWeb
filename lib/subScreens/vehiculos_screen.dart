import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_campos_vehiculos.dart';
import 'package:horarios_web/widgets/modal_editar_vehiculo.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/modal_agregar_vehiculo.dart';

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

  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();
  StreamController vehiController = StreamController<List<DataRow>>();

  List<int> selectedRows = [];

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
          Row(
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
                          prefixIconColor: Colors.black54,
                          hintText: 'Buscar',
                          prefixIcon: Icon(Icons.search)),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: [
                    FloatingActionButton(
                      heroTag: 'b7',
                      onPressed: () async {
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
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'normal1',
                      onPressed: () async {
                        if (selectedRows.isNotEmpty &&
                            selectedRows.length < 2) {
                          CamposVehiculos campos =
                              CamposVehiculos.fromRow(rows, selectedRows.first);
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return ModalEditarVehiculo(
                                  asientosController: campos.asientosController,
                                  descripcionController:
                                      campos.descripcionController,
                                  matriculaController:
                                      campos.matriculaController,
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
                                    title:
                                        const Text('Seleccion unica requerida'),
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
                      },
                      child: const Icon(Icons.edit),
                    ),
                    FloatingActionButton(
                      heroTag: 'b6',
                      onPressed: () {
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
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Si, continuar'),
                                    onPressed: () {
                                      deleteReg();
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
                      },
                      child: const Icon(
                        Icons.delete,
                      ),
                    )
                  ],
                ),
              )
            ],
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
                              DataColumn(label: Text('Nro')),
                              DataColumn(label: Text('Tipo')),
                              DataColumn(label: Text('Descripcion')),
                              DataColumn(label: Text('Matricula')),
                              DataColumn(label: Text('Asientos')),
                              DataColumn(label: Text('Usuario')),
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
  bool get wantKeepAlive => true;
}
