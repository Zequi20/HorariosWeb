import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<int> idList = [];
  DateTime curDate = DateTime.now();
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];

  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();
  StreamController vehiController = StreamController<List<DataRow>>();

  @override
  void initState() {
    fetchRows();
    super.initState();
  }

  @override
  void dispose() {
    vehiController.close();
    super.dispose();
  }

  void deleteReg(String reg) async {
    if (idList.contains(int.parse(reg))) {
      var requestPost = http.Request(
          'DELETE', Uri.parse('http://190.52.165.206:3000/delete_vehicles'));

      requestPost.bodyFields = {'id': reg};
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
                        Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      heroTag: 'b6',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Eliminar registro'),
                              content: Wrap(
                                children: [
                                  const Text(
                                      'Introduzca el Id del registro a borrar'),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                        filled: true, fillColor: Colors.white),
                                    controller: deleteController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9\.]'))
                                    ],
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                  style: const ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
                                          Colors.white)),
                                  child: const Text('Eliminar registro'),
                                  onPressed: () {
                                    if (deleteController.text.isNotEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Confirmar'),
                                              content: const Text(
                                                  'Seguro que desea eliminar un registro?'),
                                              actions: [
                                                TextButton(
                                                  style: const ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white)),
                                                  child: const Text('Si'),
                                                  onPressed: () {
                                                    deleteReg(deleteController
                                                        .text
                                                        .trim()
                                                        .replaceAll('.', ''));
                                                  },
                                                ),
                                                TextButton(
                                                  style: const ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white)),
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                ),
                                TextButton(
                                  style: const ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
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
                              .map((cell) => cell.child.toString())
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
                        child: DataTable(columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Nro')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Descripcion')),
                          DataColumn(label: Text('Matricula')),
                          DataColumn(label: Text('Asientos')),
                          DataColumn(label: Text('Usuario')),
                        ], rows: rows),
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
    for (var element in jsonResponse) {
      idList.add(element['ID']);
      fetchedRows.add(DataRow(cells: [
        DataCell(Text(element['ID'].toString())),
        DataCell(Text(element['NUMBER'].toString())),
        DataCell(Text(element['TYPE'].toString())),
        DataCell(Text(element['DESCRIPTION'])),
        DataCell(Text(element['LICENSE_PLATE'].toString().trim())),
        DataCell(Text(element['SEATS'].toString().trim())),
        DataCell(Text(element['NAME'].toString().split('T')[0])),
      ]));
    }

    return fetchedRows;
  }

//{"ID","TYPE","NAME","CI","DRIVING_LICENSE","BIRTH_DATE","MARITAL_STATUS","ADDRESS","PHONE","USUARIO","DISCHARGE_DATE""}
  @override
  bool get wantKeepAlive => true;
}
