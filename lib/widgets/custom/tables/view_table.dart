import 'package:flutter/services.dart';
import 'package:horarios_web/widgets/custom/fields/custom_in_form_time_picker.dart';
import 'package:horarios_web/widgets/custom/fields/sugest_text_field.dart';
import 'package:horarios_web/widgets/modals/viaje/modal_editar_viaje.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';

class ViewTable extends StatefulWidget {
  const ViewTable(
      {super.key,
      required this.grupos,
      required this.fecha,
      required this.updateParent});
  final List<Group> grupos;
  final String fecha;
  final VoidCallback updateParent;
  @override
  State<ViewTable> createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  late Table mainTable;
  bool upAndDown = true;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  FocusScopeNode tablaFoco = FocusScopeNode();
  @override
  void initState() {
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
    List<TableRow> lista = widget.grupos
        .map((e) => TableRow(children: [
              Table(
                border: TableBorder(
                    horizontalInside: const BorderSide(color: Colors.black),
                    bottom: BorderSide(color: principalColor, width: 1),
                    top: BorderSide(color: principalColor, width: 1)),
                children: [
                  TableRow(children: [
                    Container(
                      color: resaltadoColor,
                      padding: const EdgeInsets.all(4),
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
                          0: FractionColumnWidth(1 / 16),
                          1: FractionColumnWidth(1 / 10),
                          2: FractionColumnWidth(1 / 6),
                          3: FractionColumnWidth(1 / 6),
                          4: FractionColumnWidth(1 / 16),
                          5: FractionColumnWidth(1 / 6),
                          6: FractionColumnWidth(1 / 20),
                        },
                        children: addEntryRow(
                            e.id,
                            widget.fecha,
                            e.travelsData.isNotEmpty
                                ? e.travelsData
                                    .map((data) => TableRow(children: [
                                          TableCell(
                                              child: Text(
                                            data['DEPARTURE_TIME']
                                                .toString()
                                                .split('.')[0],
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                              child: Text(
                                            data['VEHICLE'].toString(),
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                              child: Text(
                                            data['DRIVER1'],
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                              child: Text(
                                            data['DRIVER2'],
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                              child: Text(
                                            data['ARRIVAL_TIME']
                                                .toString()
                                                .split('.')[0],
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                              child: Text(
                                            data['NOTE'],
                                            textAlign: TextAlign.center,
                                          )),
                                          TableCell(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: FocusButton(
                                                    onClick: () async {
                                                      await showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return ModalEditarViaje(
                                                              datos: data,
                                                              grupoId: e.id,
                                                            );
                                                          });
                                                      widget.updateParent();
                                                      tablaFoco.requestFocus();
                                                    },
                                                    icono: Icons.edit,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FocusButton(
                                                    onClick: () {
                                                      onDelete(
                                                          data['ID'].toString(),
                                                          data);
                                                    },
                                                    icono: Icons.delete,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ]))
                                    .toList()
                                : []),
                      )
                    ],
                  )
                ],
              )
            ]))
        .toList();

    mainTable =
        Table(border: TableBorder.all(color: Colors.black), children: lista);
    return FocusScope(
        onKeyEvent: (node, event) {
          if (event is KeyUpEvent &&
              event.logicalKey == LogicalKeyboardKey.arrowDown &&
              upAndDown) {
            node.focusInDirection(TraversalDirection.down);
            return KeyEventResult.handled;
          }
          if (event is KeyUpEvent &&
              event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              upAndDown) {
            node.focusInDirection(TraversalDirection.left);
            return KeyEventResult.handled;
          }
          if (event is KeyUpEvent &&
              event.logicalKey == LogicalKeyboardKey.arrowRight &&
              upAndDown) {
            node.focusInDirection(TraversalDirection.right);
            return KeyEventResult.handled;
          }
          if (event is KeyUpEvent &&
              event.logicalKey == LogicalKeyboardKey.arrowUp &&
              upAndDown) {
            node.focusInDirection(TraversalDirection.up);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        autofocus: true,
        child: SingleChildScrollView(child: mainTable));
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

  List<TableRow> addEntryRow(int id, String fecha, List<TableRow> data) {
    TextEditingController guardaController = TextEditingController();
    TextEditingController choferController = TextEditingController();
    TextEditingController cocheController = TextEditingController();
    TextEditingController llegadaController = TextEditingController();
    TextEditingController partidaController = TextEditingController();
    TextEditingController notaController = TextEditingController();
    //FocusNode foco = FocusNode();
    data.add(TableRow(children: [
      TableCell(
          child: MetalGrad(
        child: InFormTimePicker(
          horaController: partidaController,
        ),
      )),
      TableCell(
          child: MetalGrad(
        child: AsyncAutocomplete(
          icon: Icons.bus_alert,
          dataController: cocheController,
          link: 'http://190.52.165.206:3000/vehicles',
          label: 'coche',
          filtro: 'NUMBER',
          setUpAndDown: (bool value) {
            upAndDown = value;
          },
        ),
      )),
      TableCell(
          child: MetalGrad(
        child: AsyncAutocomplete(
          icon: Icons.person,
          dataController: choferController,
          link: 'http://190.52.165.206:3000/just_drivers',
          label: 'chofer',
          filtro: 'NAME',
          setUpAndDown: (bool value) {
            upAndDown = value;
          },
        ),
      )),
      TableCell(
          child: MetalGrad(
        child: AsyncAutocomplete(
          icon: Icons.person,
          dataController: guardaController,
          link: 'http://190.52.165.206:3000/just_copilots',
          label: 'guarda',
          filtro: 'NAME',
          setUpAndDown: (bool value) {
            upAndDown = value;
          },
        ),
      )),
      TableCell(
          child: MetalGrad(
        child: InFormTimePicker(
          horaController: llegadaController,
        ),
      )),
      TableCell(
          child: MetalGrad(
        child: SugestTextField(
          notaController: notaController,
        ),
      )),
      TableCell(
          child: FocusButton(
        onClick: () {
          onAccept(
            id.toString(),
            guardaController.text,
            choferController.text,
            cocheController.text,
            llegadaController.text,
            partidaController.text,
            notaController.text,
            dateFormaterString(fecha),
          );
        },
        icono: Icons.add_box_sharp,
      ))
    ]));

    return data;
  }

  void onAccept(
    String grupo,
    String guarda,
    String chofer,
    String coche,
    String llegada,
    String partida,
    String nota,
    String fecha,
  ) async {
    if (validateFields([guarda, chofer, coche, llegada, partida])) {
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/add_travels'));

      requestPost.bodyFields = {
        'grupo': grupo,
        'coche': coche,
        'chofer': chofer,
        'guarda': guarda,
        'nota': nota,
        'partida': partida,
        'llegada': llegada,
        'fecha': fecha
      };
      http.StreamedResponse responseStream = await requestPost.send();

      if (responseStream.statusCode == 200) {
        if (mounted) {
          widget.updateParent();
        }
      } else {
        if (mounted) {
          msgBox('Error', 'Algo ha salido mal');
          tablaFoco.requestFocus();
        }
      }
    } else {
      if (mounted) {
        msgBox('Campos obligatorios', 'Faltan uno o mas campos');
        tablaFoco.requestFocus();
      }
    }
  }

  String dateFormaterString(String inputDate) {
    List<String> numbers = inputDate.split('/');
    if (numbers.length > 1) {
      return '${numbers[2]}-${numbers[1]}-${numbers[0]}';
    }
    return inputDate;
  }

  bool validateFields(List<String> lista) {
    for (var i in lista) {
      if (i.isEmpty) return false;
      break;
    }
    return true;
  }

  void onDelete(String idReg, Map data) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar registro'),
          content: Wrap(
            children: const [Text('Seguro que desea eliminar este registro?')],
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)),
              child: const Text('Si, continuar'),
              onPressed: () async {
                await deleteReg(idReg);
                widget.updateParent();
              },
            ),
            TextButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white)),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  Future deleteReg(String id) async {
    var requestPost = http.Request(
        'DELETE', Uri.parse('http://190.52.165.206:3000/delete_travels'));

    String idList = id;

    requestPost.bodyFields = {'id': idList};
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
                      setState(() {
                        tablaFoco.requestFocus();
                      });
                    },
                  ),
                ],
              );
            });
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop(true);
        msgBox('Error', 'Algo ha salido mal');
        tablaFoco.requestFocus();
      }
    }
  }
}

class FocusButton extends StatefulWidget {
  const FocusButton(
      {super.key,
      this.resaltadoColor = Colors.orange,
      this.principalColor = const Color.fromARGB(255, 99, 1, 1),
      required this.onClick,
      this.icono = Icons.arrow_drop_up,
      this.text = ''});
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
      child: widget.text.isEmpty
          ? TextButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.focused)) {
                      return widget.resaltadoColor;
                    }
                    return Colors.black12;
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
            )
          : IconButton(
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
            ),
    );
  }
}

class MetalGrad extends StatefulWidget {
  const MetalGrad({super.key, required this.child});
  final Widget child;

  @override
  State<MetalGrad> createState() => _MetalGradState();
}

class _MetalGradState extends State<MetalGrad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black38, Colors.white, Colors.black38])),
      child: widget.child,
    );
  }
}


/* app.post('/duplicate_travels', (req, res) => {
	const begin = req.body.begin;
	const end = req.body.end;
  pool.get((err, db) => {
    if (err) {
      console.error(err);
      res.status(500).json({ error: 'Error getting connection from the pool' });
      return;
    }

    db.transaction((err, transaction) => {
      if (err) {
        console.error(err);
        db.detach();
        res.status(500).json({ error: 'Error starting transaction' });
        return;
      }

      const insertQuery = `INSERT INTO TRAVELS (ID_GROUP, ID_VEHICLE, ID_FIRST_DRIVER, ID_SECOND_DRIVER, DEPARTURE_TIME, ARRIVAL_TIME, NOTE, KM, "DATE")
			SELECT ID_GROUP, ID_VEHICLE, ID_FIRST_DRIVER, ID_SECOND_DRIVER, DEPARTURE_TIME, ARRIVAL_TIME, NOTE, KM, '${begin}'
			FROM TRAVELS t
			WHERE t."DATE" = '${end}';
			`; // Tu consulta de inserción
      transaction.query(insertQuery, (err, result) => {
        if (err) {
          console.error(err);
          transaction.rollback(() => {
            transaction.commit(() => {
              db.detach();
              res.status(500).json({ error: 'Error executing query' });
            });
          });
          return;
        }

        transaction.commit(() => {
          db.detach();
          res.status(200).json({ message: 'Data inserted and committed successfully' });
        });
      });
    });
  });
  }); */