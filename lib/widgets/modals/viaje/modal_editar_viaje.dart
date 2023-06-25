import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_conductor.dart';
import 'package:horarios_web/models/model_vehiculos.dart';
import 'package:horarios_web/widgets/custom/fields/custom_time_picker.dart';
import 'package:http/http.dart' as http;

class ModalEditarViaje extends StatefulWidget {
  const ModalEditarViaje(
      {super.key, required this.grupoId, required this.seleccion});
  final int grupoId;
  final DataRow seleccion;

  @override
  State<ModalEditarViaje> createState() => _ModalEditarViajeState();
}

class _ModalEditarViajeState extends State<ModalEditarViaje> {
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  int selectedVehicle = -1;
  int selectedDriver = -1;
  int selectedGuarda = -2;
  List<Vehiculos> listaVehiculos = [Vehiculos(-1, '(vacio)', '(vacio)')];
  List<Conductor> listaConductores = [Conductor(-1, '(nadie)', 'c')];
  List<Conductor> listaGuardas = [Conductor(-2, '(nadie)', 'g')];
  var controller = ScrollController();
  var partidaController = TextEditingController();
  var llegadaController = TextEditingController();
  var notaController = TextEditingController();
  late String idViaje;

  var defaultDivider = const Divider(
    color: Colors.transparent,
    height: 24,
  );
  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    List<DataCell> aux = widget.seleccion.cells;
    idViaje = (aux[0].child as Text).data!;
    partidaController.text = (aux[1].child as Text).data!;
    llegadaController.text = (aux[2].child as Text).data!;
    selectedVehicle = int.parse((aux[3].child as Text)
        .key
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), ''));

    selectedDriver = int.parse((aux[4].child as Text)
        .key
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), ''));
    selectedGuarda = int.parse((aux[5].child as Text)
        .key
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), ''));
    notaController.text = (aux[6].child as Text).data!;
  }

  Future fetchVehicles() async {
    List<Vehiculos> vehiculos;
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/vehicles'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      vehiculos = data
          .map((elem) => Vehiculos(
              elem['ID'], elem['LICENSE_PLATE'], elem['NUMBER'].toString()))
          .toList();

      vehiculos.insert(0, Vehiculos(-1, '(vacio)', '(vacio)'));
    } else {
      throw Exception('Error al obtener registros');
    }

    return vehiculos;
  }

  Future fetchDrivers() async {
    List<Conductor> conductores;
    List<Conductor> guardas;

    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/drivers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Conductor> listaDatos = data
          .map((elem) => Conductor(elem['ID'], elem['NAME'], elem['TYPE']))
          .toList();

      conductores = listaDatos
          .where((element) => element.tipo.toLowerCase() == 'c')
          .toList();

      guardas = listaDatos
          .where((element) => element.tipo.toLowerCase() == 'g')
          .toList();

      conductores.insert(0, Conductor(-1, '(nadie)', 'c'));
      guardas.insert(0, Conductor(-2, '(nadie)', 'g'));
    } else {
      throw Exception('Error al obtener registros');
    }
    return [conductores, guardas];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FilledButton.icon(
            onPressed: () async {
              if (selectedDriver > -1 &&
                  selectedGuarda > -1 &&
                  selectedVehicle > -1 &&
                  llegadaController.text.isNotEmpty &&
                  partidaController.text.isNotEmpty &&
                  notaController.text.isNotEmpty) {
                var requestPost = http.Request('POST',
                    Uri.parse('http://190.52.165.206:3000/edit_travels'));
                requestPost.bodyFields = {
                  'id': idViaje,
                  'grupo': widget.grupoId.toString(),
                  'coche': selectedVehicle.toString(),
                  'chofer': selectedDriver.toString(),
                  'guarda': selectedGuarda.toString(),
                  'nota': notaController.text,
                  'partida': partidaController.text,
                  'llegada': llegadaController.text,
                };
                http.StreamedResponse responseStream = await requestPost.send();

                if (responseStream.statusCode == 200) {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Operacion exitosa'),
                            content:
                                const Text('Operacion realizada con exito :)'),
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
                } else {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Operacion fallida'),
                            content: Text(
                                'Algo ha salido mal :(${responseStream.statusCode})'),
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
              } else {
                if (mounted) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Campos vacios'),
                          content: const Text('Faltan campos por completar :)'),
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
            },
            icon: const Icon(Icons.save),
            label: const Text(
              'Agregar',
            )),
        FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel),
            label: const Text(
              'Cancelar',
            ))
      ],
      title: const Text('Agregar Viaje'),
      content: SingleChildScrollView(
        clipBehavior: Clip.antiAlias,
        controller: controller,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Hora de partida')),
                Expanded(
                  flex: 2,
                  child: CustomTimePicker(
                      timeController: partidaController, title: 'Salida'),
                ),
              ],
            ),
            defaultDivider,
            Row(
              children: [
                const Expanded(child: Text('Hora de retorno')),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onTap: () async {
                      llegadaController.text = await showTimePicker(
                        helpText: 'Fijar hora de retorno',
                        cancelText: 'Cancelar',
                        confirmText: 'Aceptar',
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                      ).then((value) {
                        if (value != null) {
                          return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
                        } else {
                          return llegadaController.text;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Hora de retorno',
                        filled: true,
                        fillColor: Colors.white),
                    readOnly: true,
                    controller: llegadaController,
                  ),
                ),
              ],
            ),
            defaultDivider,
            Row(
              children: [
                const Expanded(child: Text('Nota')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: notaController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese una nota',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            defaultDivider,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: gradPrincipalColor),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  FutureBuilder(
                      future: fetchVehicles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listaVehiculos = snapshot.data;
                          return Row(
                            children: [
                              const Expanded(child: Text('Vehiculo')),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField(
                                  decoration: defaultDecoration,
                                  isExpanded: true,
                                  focusColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  menuMaxHeight: 256,
                                  value: selectedVehicle,
                                  items: listaVehiculos
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.placa == '(vacio)'
                                                  ? '(vacio)'
                                                  : '${e.numero} (${e.placa})',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedVehicle = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          ));
                        }
                      }),
                  defaultDivider,
                  Row(
                    children: const [
                      Expanded(child: Text('Chofer')),
                      Expanded(child: Text('Guarda'))
                    ],
                  ),
                  defaultDivider,
                  FutureBuilder(
                      future: fetchDrivers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listaConductores = snapshot.data[0];
                          listaGuardas = snapshot.data[1];
                          return Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  decoration: defaultDecoration,
                                  isExpanded: true,
                                  focusColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  menuMaxHeight: 256,
                                  value: selectedDriver,
                                  items: listaConductores
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.nombre,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedDriver = value!;
                                    });
                                  },
                                ),
                              ),
                              const Divider(
                                indent: 12,
                              ),
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField(
                                  decoration: defaultDecoration,
                                  isExpanded: true,
                                  focusColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  menuMaxHeight: 256,
                                  value: selectedGuarda,
                                  items: listaGuardas
                                      .map((e) => DropdownMenuItem(
                                          value: e.id,
                                          child: Text(
                                            e.nombre,
                                            overflow: TextOverflow.ellipsis,
                                          )))
                                      .toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedGuarda = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          ));
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
