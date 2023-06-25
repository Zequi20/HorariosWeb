import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_conductor.dart';
import 'package:horarios_web/models/model_vehiculos.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/custom_time_picker.dart';
import 'package:horarios_web/widgets/custom/fields/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalAgregarViaje extends StatefulWidget {
  const ModalAgregarViaje({super.key, required this.grupoId});
  final int grupoId;
  @override
  State<ModalAgregarViaje> createState() => _ModalAgregarViajeState();
}

class _ModalAgregarViajeState extends State<ModalAgregarViaje> {
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  List<Vehiculos> listaVehiculos = [Vehiculos(-1, '(vacio)', '(vacio)')];
  List<Conductor> listaConductores = [Conductor(-1, '(nadie)', 'c')];
  List<Conductor> listaGuardas = [Conductor(-2, '(nadie)', 'g')];
  var controller = ScrollController();
  var partidaController = TextEditingController();
  var llegadaController = TextEditingController();
  var notaController = TextEditingController();
  var cocheController = TextEditingController();
  var choferController = TextEditingController();
  var guardaController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FilledButton.icon(
            onPressed: () async {
              if (guardaController.text.isNotEmpty &&
                  choferController.text.isNotEmpty &&
                  cocheController.text.isNotEmpty &&
                  llegadaController.text.isNotEmpty &&
                  partidaController.text.isNotEmpty &&
                  notaController.text.isNotEmpty) {
                final response = await http.get(
                    Uri.parse('http://190.52.165.206:3000/max_travels_id'));
                int idMax = json.decode(response.body)[0]['MAX'];

                var requestPost = http.Request('POST',
                    Uri.parse('http://190.52.165.206:3000/add_travels'));

                idMax += 1;
                requestPost.bodyFields = {
                  'id': idMax.toString(),
                  'grupo': widget.grupoId.toString(),
                  'coche': cocheController.text,
                  'chofer': choferController.text,
                  'guarda': guardaController.text,
                  'nota': notaController.text,
                  'partida': partidaController.text,
                  'llegada': llegadaController.text,
                };
                http.StreamedResponse responseStream = await requestPost.send();

                if (responseStream.statusCode == 200) {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                    msgBox(
                        'Operacion exitosa', 'Operacion realizada con exito');
                  }
                } else {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                    msgBox('Error', 'Algo ha salido mal');
                  }
                }
              } else {
                if (mounted) {
                  msgBox('Campos obligatorios', 'Faltan uno o mas campos');
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
      scrollable: true,
      title: const Text('Agregar Viaje'),
      content: SizedBox(
        width: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Hora de Salida')),
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
                const Expanded(child: Text('Hora de Retorno')),
                Expanded(
                  flex: 2,
                  child: CustomTimePicker(
                      timeController: llegadaController, title: 'Retorno'),
                ),
              ],
            ),
            defaultDivider,
            ModalRow(
                sideTitle: 'Ingrese Nota',
                child: CustomTextField(
                    textController: notaController, hint: 'Nota')),
            defaultDivider,
            AsyncAutocomplete(
              dataController: choferController,
              link: 'http://190.52.165.206:3000/just_drivers',
              label: 'Chofer',
              filtro: 'NAME',
            ),
            defaultDivider,
            AsyncAutocomplete(
              dataController: guardaController,
              link: 'http://190.52.165.206:3000/just_copilots',
              label: 'Guarda',
              filtro: 'NAME',
            ),
            defaultDivider,
            AsyncAutocomplete(
              dataController: cocheController,
              link: 'http://190.52.165.206:3000/vehicles',
              label: 'Coches',
              filtro: 'NUMBER',
            ),
          ],
        ),
      ),
    );
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
}
