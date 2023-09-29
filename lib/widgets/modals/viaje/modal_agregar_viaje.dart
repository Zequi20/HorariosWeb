import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/custom_time_picker.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalAgregarViaje extends StatefulWidget {
  const ModalAgregarViaje(
      {super.key, required this.grupoId, required this.fecha});
  final int grupoId;
  final String fecha;
  @override
  State<ModalAgregarViaje> createState() => _ModalAgregarViajeState();
}

class _ModalAgregarViajeState extends State<ModalAgregarViaje> {
  //Colores
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  //Controladores de texto
  var partidaController = TextEditingController();
  var llegadaController = TextEditingController();
  var notaController = TextEditingController();
  var cocheController = TextEditingController();
  var choferController = TextEditingController();
  var guardaController = TextEditingController();

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
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Agregar Viaje',
        content: [
          ModalRow(
              sideTitle: 'Ingrese horario de Partida',
              child: CustomTimePicker(
                  timeController: partidaController, title: 'Hora de salida')),
          ModalRow(
              sideTitle: 'Ingrese horario de Retorno',
              child: CustomTimePicker(
                  timeController: llegadaController, title: 'Hora de retorno')),
          ModalRow(
            sideTitle: 'Ingrese Chofer',
            child: AsyncAutocomplete(
              icon: Icons.person,
              dataController: choferController,
              link: 'http://190.52.165.206:3000/just_drivers',
              label: 'Nombre del chofer',
              filtro: 'NAME',
              setUpAndDown: (bool value) {},
            ),
          ),
          ModalRow(
            sideTitle: 'Ingrese Guarda',
            child: AsyncAutocomplete(
              icon: Icons.person,
              dataController: guardaController,
              link: 'http://190.52.165.206:3000/just_copilots',
              label: 'Nombre del guarda',
              filtro: 'NAME',
              setUpAndDown: (bool value) {},
            ),
          ),
          ModalRow(
            sideTitle: 'Ingrese numero del coche',
            child: AsyncAutocomplete(
              icon: Icons.bus_alert,
              dataController: cocheController,
              link: 'http://190.52.165.206:3000/vehicles',
              label: 'Numero de coche',
              filtro: 'NUMBER',
              setUpAndDown: (bool value) {},
            ),
          ),
          ModalRow(
              sideTitle: 'Ingrese Nota (Opcional)',
              child: CustomTextField(
                  icon: Icons.note_outlined,
                  textController: notaController,
                  hint: 'Nota')),
        ]);
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

  Future onAccept() async {
    if (validateFields([
      guardaController.text,
      choferController.text,
      cocheController.text,
      llegadaController.text,
      partidaController.text
    ])) {
      final response = await http
          .get(Uri.parse('http://190.52.165.206:3000/max_travels_id'));
      int idMax = json.decode(response.body)[0]['MAX'];

      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/add_travels'));

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
        'fecha': widget.fecha
      };
      http.StreamedResponse responseStream = await requestPost.send();

      if (responseStream.statusCode == 200) {
        if (mounted) {
          Navigator.of(context).pop(true);
          msgBox('Operacion exitosa', 'Operacion realizada con exito');
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
  }

  bool validateFields(List<String> lista) {
    for (var i in lista) {
      if (i.isEmpty) return false;
      break;
    }
    return true;
  }
}
