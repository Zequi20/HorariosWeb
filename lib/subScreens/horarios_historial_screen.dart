import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HorariosGuardados extends StatefulWidget {
  const HorariosGuardados({super.key, this.userId = 0});
  final int? userId;

  @override
  State<HorariosGuardados> createState() => _HorariosGuardadosState();
}

class _HorariosGuardadosState extends State<HorariosGuardados>
    with AutomaticKeepAliveClientMixin {
  var horizontalController = ScrollController();
  var verticalController = ScrollController();
  List selectedRows = [];
  List<DataRow> rows = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: getRows(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                rows = snapshot.data;
                return Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          int ver = -1;
                          if (selectedRows.isNotEmpty) {
                            ver = selectedRows.first;
                          }
                          if (ver > -1) {
                            if (kDebugMode) {
                              print(rows[ver]
                                  .cells
                                  .map((e) => (e.child as Text).data)
                                  .toList());
                            }
                          }
                        },
                        icon: const Icon(Icons.view_array)),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                            onSelectAll: (value) {
                              int indice = -1;
                              setState(() {
                                if (value!) {
                                  selectedRows.addAll(rows.map((e) {
                                    ++indice;
                                    return indice;
                                  }).toList());
                                } else {
                                  selectedRows.clear();
                                }
                              });
                            },
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Fecha')),
                              DataColumn(label: Text('Hora')),
                              DataColumn(label: Text('Usuario')),
                              DataColumn(label: Text('Compania')),
                            ],
                            rows: rows),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              }
            },
          )
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
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/REPORTS'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);

    for (var i = 0; i < jsonResponse.length; i++) {
      retorno.add(DataRow(
          selected: selectedRows.contains(i),
          onSelectChanged: (value) {
            setState(() {
              if (value!) {
                selectedRows.add(i);
              } else {
                selectedRows.remove(i);
              }
            });
          },
          cells: [
            DataCell(Text(jsonResponse[i]['ID'].toString())),
            DataCell(Text(jsonResponse[i]['DATE_OF'].toString().split('T')[0])),
            DataCell(Text(jsonResponse[i]['TIME_OF']
                .toString()
                .split('T')[1]
                .replaceAll('Z', ''))),
            DataCell(Text(jsonResponse[i]['NAME'])),
            DataCell(Text(jsonResponse[i]['COMPANIE'])),
          ]));
    }

    return retorno;
  }

  @override
  bool get wantKeepAlive => true;
}