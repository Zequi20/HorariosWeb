import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/fields/custom_date_picker.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';

class ViewTable extends StatefulWidget {
  const ViewTable({super.key, required this.grupos});
  final List<Group> grupos;
  @override
  State<ViewTable> createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  late Table mainTable;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  @override
  void initState() {
    escarapela();

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

  void escarapela() {}

  @override
  Widget build(BuildContext context) {
    List<TableRow> lista = widget.grupos
        .map((e) => TableRow(children: [
              Table(
                border: const TableBorder(
                    horizontalInside: BorderSide(color: Colors.black)),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        e.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
                  TableRow(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: const TableBorder(
                            verticalInside: BorderSide(color: Colors.black)),
                        columnWidths: const {
                          0: FractionColumnWidth(1 / 20),
                          1: FractionColumnWidth(1 / 6),
                          2: FractionColumnWidth(1 / 6),
                          3: FractionColumnWidth(1 / 6),
                          4: FractionColumnWidth(1 / 20),
                          5: FractionColumnWidth(1 / 6),
                          6: FractionColumnWidth(1 / 20),
                        },
                        children: addEntryRow([
                          TableRow(
                              children: e.travelsData.isNotEmpty
                                  ? [
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['DEPARTURE_TIME']
                                            .toString()
                                            .split('.')[0],
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
                                        e.travelsData.first['ARRIVAL_TIME']
                                            .toString()
                                            .split('.')[0],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: Text(
                                        e.travelsData.first['NOTE'],
                                        textAlign: TextAlign.center,
                                      )),
                                      TableCell(
                                          child: IconButton(
                                              onPressed: () async {
                                                msgBox('kk', 'kk');
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: principalColor,
                                              )))
                                    ]
                                  : [])
                        ]),
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
                5: FractionColumnWidth(1 / 6),
                6: FractionColumnWidth(1 / 20)
              },
              children: const [
                TableRow(children: [
                  TableCell(
                      child: Text(
                    'Salida',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TableCell(
                      child: Text(
                    'Coche',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TableCell(
                      child: Text(
                    'Conductor',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TableCell(
                      child: Text(
                    'Guarda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TableCell(
                      child: Text(
                    'Retorno',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  TableCell(
                      child: Text(
                    'Nota',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  TableCell(
                      child: Text(
                    'Acciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                ])
              ],
            )
          ]),
    );

    mainTable =
        Table(border: TableBorder.all(color: Colors.black), children: lista);
    return mainTable;
  }

  Future<void> msgBox(String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                autofocus: true,
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  List<TableRow> addEntryRow(List<TableRow> data) {
    data.add(TableRow(
        children: List.generate(
            7,
            (index) => TableCell(
                  child: CustomTextField(
                    textController: TextEditingController(),
                    hint: 'Ho',
                  ),
                ))));

    if (data.first.children!.isEmpty) {
      data.removeAt(0);
    }

    return data;
  }
}
