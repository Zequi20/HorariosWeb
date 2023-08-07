import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';

class ViewTable extends StatefulWidget {
  const ViewTable({super.key, required this.grupos});
  final List<Group> grupos;
  @override
  State<ViewTable> createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  late Table mainTable;

  @override
  void initState() {
    List<TableRow> lista = widget.grupos
        .map((e) => TableRow(children: [
              Table(
                border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.black)),
                children: [
                  TableRow(children: [
                    Text(
                      e.name,
                      textAlign: TextAlign.center,
                    )
                  ]),
                  TableRow(
                    children: [
                      Table(
                        border: const TableBorder(
                            verticalInside: BorderSide(color: Colors.black)),
                        columnWidths: const {
                          0: FractionColumnWidth(1 / 20),
                          1: FractionColumnWidth(1 / 6),
                          2: FractionColumnWidth(1 / 6),
                          3: FractionColumnWidth(1 / 6),
                          4: FractionColumnWidth(1 / 20),
                          5: FractionColumnWidth(1 / 6)
                        },
                        children: [
                          TableRow(
                              children: e.travelsData.isNotEmpty
                                  ? [
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['DEPARTURE_TIME'],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['VEHICLE']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['DRIVER1'],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['DRIVER2'],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['ARRIVAL_TIME'],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['NOTE'],
                                        textAlign: TextAlign.center,
                                      ))
                                    ]
                                  : [const Text(' ')])
                        ],
                      )
                    ],
                  )
                ],
              )
            ]))
        .toList();
    lista.insert(
      0,
      TableRow(
          decoration: const BoxDecoration(color: Colors.orange),
          children: [
            Table(
              border: const TableBorder(
                  verticalInside: BorderSide(color: Colors.black)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FractionColumnWidth(1 / 20),
                1: FractionColumnWidth(1 / 6),
                2: FractionColumnWidth(1 / 6),
                3: FractionColumnWidth(1 / 6),
                4: FractionColumnWidth(1 / 20),
                5: FractionColumnWidth(1 / 6)
              },
              children: const [
                TableRow(children: [
                  TableCell(
                      child: Text(
                    'Salida',
                    textAlign: TextAlign.center,
                  )),
                  TableCell(
                      child: Text(
                    'Coche',
                    textAlign: TextAlign.center,
                  )),
                  TableCell(
                      child: Text(
                    'Conductor',
                    textAlign: TextAlign.center,
                  )),
                  TableCell(
                      child: Text(
                    'Guarda',
                    textAlign: TextAlign.center,
                  )),
                  TableCell(
                      child: Text(
                    'Retorno',
                    textAlign: TextAlign.center,
                  )),
                  TableCell(
                      child: Text(
                    'Nota',
                    textAlign: TextAlign.center,
                  ))
                ])
              ],
            )
          ]),
    );
    mainTable =
        Table(border: TableBorder.all(color: Colors.black), children: lista);
    super.initState();
  }

  checkEmptyGroup() {
    if (widget.grupos.isNotEmpty) {
      return mainTable;
    } else {
      return const Center(
        child: Text('Esta vacio'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return mainTable;
  }
}
