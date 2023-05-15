import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/modal_agregar_chofer.dart';

class ScreenChoferes extends StatefulWidget {
  const ScreenChoferes({super.key, this.userId = 0});
  final int? userId;

  @override
  State<ScreenChoferes> createState() => _ScreenChoferesState();
}

class _ScreenChoferesState extends State<ScreenChoferes>
    with AutomaticKeepAliveClientMixin {
  final verticalController = ScrollController();
  final horizontalController = ScrollController();
  List<int> idList = [];
  DateTime curDate = DateTime.now();
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];
  List<DataRow> fetchedRows = [];

  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();

  StreamController driversController = StreamController<List<DataRow>>();
  String getTipoChofer(String letra) {
    String tipo = '';
    if (letra == 'C' || letra == '1') {
      tipo = 'Chofer';
    } else if (letra == 'G' || letra == '0') {
      tipo = 'Guarda';
    } else {
      tipo = 'Indefinido';
    }
    return tipo;
  }

  String getEstadoCivil(String letra) {
    String tipo = '';
    if (letra == 'C' || letra == '1') {
      tipo = 'Casado';
    } else if (letra == 'S' || letra == '0') {
      tipo = 'Soltero';
    } else {
      tipo = 'Indefinido';
    }
    return tipo;
  }

  void deleteReg(String reg) async {
    if (idList.contains(int.parse(reg))) {
      var requestPost = http.Request(
          'DELETE', Uri.parse('http://190.52.165.206:3000/delete_drivers'));

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
  void initState() {
    super.initState();
    fetchRows();
  }

  @override
  void dispose() {
    driversController.close();
    super.dispose();
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
                      heroTag: 'b1',
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return ModalAgregarChofer(
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
                      heroTag: 'b2',
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
                child: StreamBuilder(
                    stream: driversController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (searchController.text.trim().isEmpty) {
                          rows = fetchedRows;
                        } else {
                          rows = fetchedRows.where((row) {
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
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Codigo')),
                              DataColumn(label: Text('Tipo')),
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Documento')),
                              DataColumn(label: Text('Registro')),
                              DataColumn(label: Text('Nacimiento')),
                              DataColumn(label: Text('Estado Civil')),
                              DataColumn(label: Text('Direccion')),
                              DataColumn(label: Text('Telefono')),
                              DataColumn(label: Text('Usuario')),
                              DataColumn(label: Text('Alta'))
                            ],
                            rows: rows,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchRows() async {
    fetchedRows.clear();
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    var request =
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/DRIVERS'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);
    for (var element in jsonResponse) {
      idList.add(element['ID']);
      fetchedRows.add(DataRow(cells: [
        DataCell(Text(element['ID'].toString())),
        DataCell(Text(element['CODE'].toString())),
        DataCell(Text(getTipoChofer(element['TYPE']))),
        DataCell(Text(element['NAME'])),
        DataCell(Text(element['CI'].toString().trim())),
        DataCell(Text(element['DRIVING_LICENSE'].toString().trim())),
        DataCell(Text(element['BIRTH_DATE'].toString().split('T')[0])),
        DataCell(
            Text(getEstadoCivil(element['MARITAL_STATUS'].toString().trim()))),
        DataCell(Text(element['ADDRESS'].toString().trim())),
        DataCell(Text(element['PHONE'].toString().trim())),
        DataCell(Text(element['USUARIO'].toString().trim())),
        DataCell(
            Text(element['DISCHARGE_DATE'].toString().trim().split('T')[0])),
      ]));
    }
    driversController.sink.add(fetchedRows);
  }

//{"ID","TYPE","NAME","CI","DRIVING_LICENSE","BIRTH_DATE","MARITAL_STATUS","ADDRESS","PHONE","USUARIO","DISCHARGE_DATE""}
  @override
  bool get wantKeepAlive => true;
}
