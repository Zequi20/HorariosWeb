import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/report.dart';
import 'package:horarios_web/widgets/tabla_grupos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class HorariosMantenimiento extends StatefulWidget {
  const HorariosMantenimiento({super.key, this.userId = 0});
  final int? userId;

  @override
  State<HorariosMantenimiento> createState() => _HorariosMantenimientoState();
}

class _HorariosMantenimientoState extends State<HorariosMantenimiento>
    with AutomaticKeepAliveClientMixin {
  //campos de texto
  var izquierdaController = TextEditingController();
  var derechaController = TextEditingController();
  var timeController = TextEditingController(
      text: '${DateFormat.Hm().format(DateTime.now())}:00');
  //colores
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var colorBlanco = Colors.white;
//varios

  var fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  bool childUpdate = false;
  List<Group> travels = [];
  List<Empresa> empresasList = [];
  int dropDownValue = 0;
  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );
  @override
  void initState() {
    super.initState();
    fetchTravelsByGroup();
  }

  Future<List<Empresa>> obtenerEmpresas() async {
    List<Empresa> listaEmpresas = [];
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/companies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      listaEmpresas = data
          .map((registro) => Empresa(registro['ID'], registro['NAME']))
          .toList();
      return listaEmpresas;
    } else {
      throw Exception('Error al obtener registros');
    }
  }

  Future fetchAll() async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/max_reports_id'));
    int idMax = json.decode(response.body)[0]['MAX'];
    return idMax + 1;
  }

  Future fetchTravelsByGroup() async {
    List<Group> travels = [];
    final response = await http
        .get(Uri.parse('http://190.52.165.206:3000/travels_by_group'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      for (var element in jsonData) {
        List travelList = element['TRAVELS'];
        travels
            .add(Group(element['ID'], element['NAME'].toString(), travelList));
      }
    } else {
      throw Exception('Fallo al obtener viajes por grupos');
    }
    return travels;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FutureBuilder(
            future: fetchTravelsByGroup(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Group> auxTrav = snapshot.data;

                return TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(gradPrincipalColor)),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog.fullscreen(
                              child: FutureBuilder(
                                  future: fetchAll(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      int macsimo = snapshot.data;
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Generador de reporte',
                                              style: TextStyle(
                                                  color: resaltadoColor,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              'REPORTE NRO: $macsimo',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    onTap: () async {
                                                      fechaController.text =
                                                          await showDatePicker(
                                                        cancelText: 'Cancelar',
                                                        confirmText: 'Aceptar',
                                                        initialEntryMode:
                                                            DatePickerEntryMode
                                                                .calendarOnly,
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                            1900, 1, 1),
                                                        lastDate:
                                                            DateTime.now(),
                                                        builder:
                                                            (context, child) {
                                                          return Theme(
                                                              data: ThemeData(
                                                                  colorScheme: ColorScheme.light(
                                                                      primary:
                                                                          principalColor,
                                                                      secondary:
                                                                          Colors
                                                                              .white)),
                                                              child:
                                                                  DatePickerDialog(
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        2000,
                                                                        1,
                                                                        1),
                                                                lastDate:
                                                                    DateTime
                                                                        .now(),
                                                              ));
                                                        },
                                                      ).then((value) {
                                                        if (value != null) {
                                                          return DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(value);
                                                        } else {
                                                          return fechaController
                                                              .text;
                                                        }
                                                      });
                                                    },
                                                    controller: fechaController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Seleccionar fecha',
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                    ),
                                                    readOnly: true,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: TextField(
                                                    onTap: () async {
                                                      timeController.text =
                                                          await showTimePicker(
                                                        helpText: 'Fijar hora',
                                                        cancelText: 'Cancelar',
                                                        confirmText: 'Aceptar',
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                        initialEntryMode:
                                                            TimePickerEntryMode
                                                                .inputOnly,
                                                      ).then((value) {
                                                        if (value != null) {
                                                          return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                                                        } else {
                                                          return timeController
                                                              .text;
                                                        }
                                                      });
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Hora de llegada',
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white),
                                                    readOnly: true,
                                                    controller: timeController,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          FutureBuilder(
                                            future: obtenerEmpresas(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                List<Empresa> empresas =
                                                    snapshot.data;
                                                empresasList = snapshot.data;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      DropdownButtonFormField(
                                                          value: dropDownValue,
                                                          decoration:
                                                              defaultDecoration,
                                                          isExpanded: true,
                                                          items: empresas
                                                              .map((e) =>
                                                                  DropdownMenuItem(
                                                                      value:
                                                                          e.id,
                                                                      child:
                                                                          Text(
                                                                        e.nombre,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )))
                                                              .toList(),
                                                          onChanged:
                                                              (int? valor) {
                                                            dropDownValue =
                                                                valor!;
                                                          }),
                                                );
                                              } else {
                                                return const Text(
                                                  'Cargando...',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Comentario superior',
                                                    filled: true,
                                                    fillColor: Colors.white),
                                                maxLines: null,
                                                minLines: null,
                                                expands: true,
                                                controller: izquierdaController,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Comentario inferior',
                                                    filled: true,
                                                    fillColor: Colors.white),
                                                maxLines: null,
                                                minLines: null,
                                                expands: true,
                                                controller: derechaController,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextButton.icon(
                                                      icon: Icon(
                                                        Icons.arrow_back,
                                                        color: resaltadoColor,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      label: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            5)),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color:
                                                                        resaltadoColor)),
                                                            child: Text(
                                                              'Cancelar',
                                                              style: TextStyle(
                                                                  color:
                                                                      resaltadoColor),
                                                            )),
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.picture_as_pdf,
                                                      color: resaltadoColor,
                                                    ),
                                                    onPressed: () async {
                                                      var requestPost =
                                                          http.Request(
                                                              'POST',
                                                              Uri.parse(
                                                                  'http://190.52.165.206:3000/reports_add'));
                                                      requestPost.bodyFields = {
                                                        'id':
                                                            macsimo.toString(),
                                                        'date': fechaController
                                                            .text,
                                                        'time':
                                                            timeController.text,
                                                        'user': widget.userId
                                                            .toString(),
                                                        'empre': dropDownValue
                                                            .toString()
                                                      };

                                                      http.StreamedResponse
                                                          responseStream =
                                                          await requestPost
                                                              .send();

                                                      if (responseStream
                                                                  .statusCode ==
                                                              200 &&
                                                          mounted) {
                                                        var reporte = Report(
                                                            auxTrav,
                                                            macsimo,
                                                            fechaController
                                                                .text,
                                                            dropDownValue,
                                                            widget.userId!,
                                                            empresasList);
                                                        reporte.generate(
                                                            context, [
                                                          izquierdaController
                                                              .text,
                                                          derechaController.text
                                                        ]);
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      }
                                                    },
                                                    label: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5)),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color:
                                                                      resaltadoColor)),
                                                          child: Text(
                                                            'Generar',
                                                            style: TextStyle(
                                                                color:
                                                                    resaltadoColor),
                                                          )),
                                                    )),
                                              ))
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      return const Center(
                                        child: Text(
                                          'Cargando...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                  }),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.note_add,
                      color: Colors.white,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Generador de reporte',
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
              } else {
                return const Text('Cargando...');
              }
            }),
        body: FutureBuilder(
            future: fetchTravelsByGroup(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                travels = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            height: 3,
                            color: colorBlanco,
                          ),
                      itemCount: travels.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          collapsedShape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          iconColor: colorBlanco,
                          collapsedIconColor: colorBlanco,
                          collapsedTextColor: colorBlanco,
                          collapsedBackgroundColor: principalColor,
                          textColor: colorBlanco,
                          backgroundColor: gradPrincipalColor,
                          title: Text(
                            travels[index].name,
                            textAlign: TextAlign.center,
                          ),
                          leading: Text('grupo ${travels[index].id}'),
                          children: [
                            GroupTable(
                              travels: travels,
                              index: index,
                              updateParent: updateParent,
                            ),
                          ],
                        );
                      }),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }
            }));
  }

  void updateParent() {
    setState(() {
      childUpdate = true;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
