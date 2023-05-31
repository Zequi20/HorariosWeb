import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';

class Report extends StatelessWidget {
  const Report({super.key, required this.lista});
  final List<Group> lista;
  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(
          lista.length,
          (index) => TableRow(
                children: [
                  Theme(
                    data: ThemeData(
                        dataTableTheme: const DataTableThemeData(
                            dataRowColor:
                                MaterialStatePropertyAll(Colors.white),
                            headingRowColor:
                                MaterialStatePropertyAll(Colors.white))),
                    child: DataTable(
                        columns: const [
                          DataColumn(label: Text('PARTIDA')),
                          DataColumn(label: Text('LLEGADA')),
                          DataColumn(label: Text('VEHICULO')),
                          DataColumn(label: Text('CONDUCTOR')),
                          DataColumn(label: Text('GUARDA')),
                          DataColumn(label: Text('NOTA')),
                          DataColumn(label: Text('KM')),
                        ],
                        rows: lista[index]
                            .travelsData
                            .map((e) => DataRow(cells: [
                                  DataCell(Text(e['DEPARTURE_TIME']
                                      .toString()
                                      .split('.')[0])),
                                  DataCell(Text(e['ARRIVAL_TIME']
                                      .toString()
                                      .split('.')[0])),
                                  DataCell(Text(
                                    e['VEHICLE'],
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
                                  DataCell(Text(e['KM'].toString()))
                                ]))
                            .toList()),
                  ),
                ],
              )),
    );
  }
}
