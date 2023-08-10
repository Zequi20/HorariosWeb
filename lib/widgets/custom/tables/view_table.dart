import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ]),
                  TableRow(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: const TableBorder(
                            horizontalInside: BorderSide(color: Colors.black),
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
                                        child: FocusButton(
                                            onClick: () {
                                              msgBox('Edicion', 'Aca se edita');
                                            },
                                            icono: Icons.edit,
                                            text: 'Editar'),
                                      )
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  TableCell(
                      child: Text(
                    'Coche',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  TableCell(
                      child: Text(
                    'Conductor',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  TableCell(
                      child: Text(
                    'Guarda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
                  TableCell(
                      child: Text(
                    'Retorno',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
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
    data.add(TableRow(children: [
      TableCell(
          child: CustomDatePicker(
              fechaControlador: TextEditingController(), title: 'salida')),
      TableCell(
          child: AsyncAutocomplete(
        icon: Icons.person,
        dataController: TextEditingController(),
        link: 'http://190.52.165.206:3000/just_drivers',
        label: 'chofer',
        filtro: 'NAME',
      )),
      TableCell(
          child: AsyncAutocomplete(
        icon: Icons.bus_alert,
        dataController: TextEditingController(),
        link: 'http://190.52.165.206:3000/vehicles',
        label: 'coche',
        filtro: 'NUMBER',
      )),
      TableCell(
          child: AsyncAutocomplete(
        icon: Icons.person,
        dataController: TextEditingController(),
        link: 'http://190.52.165.206:3000/just_copilots',
        label: 'guarda',
        filtro: 'NAME',
      )),
      TableCell(
          child: CustomDatePicker(
              fechaControlador: TextEditingController(), title: 'retorno')),
      TableCell(
          child: CustomTextField(
              lenght: null,
              textController: TextEditingController(),
              hint: 'Nota')),
      TableCell(
          child: FocusButton(
        onClick: () {
          msgBox('tembo', 'Tembo lgmnt jajaja');
        },
        icono: Icons.arrow_drop_up,
        text: 'Agregar',
      ))
    ]));

    if (data.first.children!.isEmpty) {
      data.removeAt(0);
    }

    return data;
  }
}

class FocusButton extends StatefulWidget {
  const FocusButton(
      {super.key,
      this.resaltadoColor = Colors.orange,
      this.principalColor = const Color.fromARGB(255, 99, 1, 1),
      required this.onClick,
      this.icono = Icons.arrow_drop_up,
      required this.text});
  final MaterialColor resaltadoColor;
  final Color principalColor;
  final IconData icono;
  final String text;
  final VoidCallback? onClick;
  @override
  State<FocusButton> createState() => _FocusButtonState();
}

class _FocusButtonState extends State<FocusButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.focused)) {
                return widget.resaltadoColor;
              }
              return Colors.white;
            },
          ),
        ),
        onPressed: widget.onClick,
        icon: Icon(
          widget.icono,
          color: widget.principalColor,
        ),
        label: Text(
          widget.text,
          style: TextStyle(color: widget.principalColor),
        ),
      ),
    );
  }
}
