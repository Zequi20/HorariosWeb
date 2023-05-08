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
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Hora')),
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Compania')),
                    ], rows: snapshot.data),
                  ),
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
    for (var element in jsonResponse) {
      retorno.add(DataRow(
          onSelectChanged: (value) {
            setState(() {});
          },
          cells: [
            DataCell(Text(element['ID'].toString())),
            DataCell(Text(element['DATE_OF'].toString().split('T')[0])),
            DataCell(Text(element['TIME_OF']
                .toString()
                .split('T')[1]
                .replaceAll('Z', ''))),
            DataCell(Text(element['NAME'])),
            DataCell(Text(element['COMPANIE'])),
          ]));
    }
    return retorno;
  }

  @override
  bool get wantKeepAlive => true;
}
