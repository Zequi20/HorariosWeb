import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/modal_agregar_grupo.dart';

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
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];

  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();

  void deleteReg(String reg) async {
    if (idList.contains(int.parse(reg))) {
      var requestPost = http.Request(
          'DELETE', Uri.parse('http://190.52.165.206:3000/delete_groups'));

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
                      heroTag: 'b4',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const ModalAgregarGrupo();
                            });
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'b3',
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
                  future: getRows(),
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
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Compania')),
                          DataColumn(label: Text('Descripcion')),
                          DataColumn(label: Text('Usuario')),
                          DataColumn(label: Text('Km')),
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

  Future<List<DataRow>> getRows() async {
    List<DataRow> retorno = [];
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
    for (var element in jsonResponse) {
      idList.add(element['ID']);
      retorno.add(DataRow(cells: [
        DataCell(Text(element['ID'].toString())),
        DataCell(Text(element['NAME'].toString())),
        DataCell(Text(element['COMPANY'].toString())),
        DataCell(Text(element['DESCRIPTION'])),
        DataCell(Text(element['USERNAME'].toString().trim())),
        DataCell(Text(element['KM'].toString().trim())),
      ]));
    }
    return retorno;
  }

//{"ID","TYPE","NAME","CI","DRIVING_LICENSE","BIRTH_DATE","MARITAL_STATUS","ADDRESS","PHONE","USUARIO","DISCHARGE_DATE""}
  @override
  bool get wantKeepAlive => true;
}
