import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/buttons/show_pdf_button.dart';
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
      body: FutureBuilder(
        future: getRows(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            rows = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: verticalController,
              child: Table(children: [
                TableRow(children: [
                  DataTable(columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Hora')),
                    DataColumn(label: Text('Usuario')),
                    DataColumn(label: Text('Empresa')),
                    DataColumn(label: Text('Documento'))
                  ], rows: rows),
                ]),
              ]),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
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
      retorno.add(DataRow(cells: [
        DataCell(Text(jsonResponse[i]['ID'].toString())),
        DataCell(Text(dateFormaterString(
            jsonResponse[i]['DATE_OF'].toString().split('T')[0]))),
        DataCell(Text(jsonResponse[i]['TIME_OF'].toString().split('.')[0])),
        DataCell(Text(jsonResponse[i]['NAME'])),
        DataCell(Text(jsonResponse[i]['COMPANIE'])),
        DataCell(ShowPdfButton(id: jsonResponse[i]['ID'].toString()))
      ]));
    }

    return retorno;
  }

  String dateFormaterString(String inputDate) {
    List<String> numbers = inputDate.split('-');
    return '${numbers[2]}/${numbers[1]}/${numbers[0]}';
  }

  @override
  bool get wantKeepAlive => false;
}
