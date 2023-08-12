import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/custom_time_picker.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalEditarViaje extends StatefulWidget {
  const ModalEditarViaje({
    super.key,
    required this.grupoId,
    required this.chofer,
    required this.guarda,
    required this.partida,
    required this.coche,
    required this.llegada,
    required this.nota,
    required this.viajeId,
  });
  final int grupoId;
  final String viajeId;
  final String chofer;
  final String guarda;
  final String partida;
  final String coche;
  final String llegada;
  final String nota;
  @override
  State<ModalEditarViaje> createState() => _ModalEditarViajeState();
}

class _ModalEditarViajeState extends State<ModalEditarViaje> {
  //scroll
  var controller = ScrollController();
  //colores
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  //controladores de texto
  var choferController = TextEditingController();
  var guardaController = TextEditingController();
  var partidaController = TextEditingController();
  var cocheController = TextEditingController();
  var llegadaController = TextEditingController();
  var notaController = TextEditingController();
  //id de viaje
  late String idViaje;
  //identificadores
  String idCoche = '';
  String idChofer = '';
  String idGuarda = '';
  //regexp
  RegExp regex = RegExp(r'\d+');

  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    choferController.text = widget.chofer;
    guardaController.text = widget.guarda;
    partidaController.text = widget.partida;
    cocheController.text = widget.coche;
    llegadaController.text = widget.llegada;
    notaController.text = widget.nota;
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Editar Viaje',
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
              id: idChofer,
              dataController: choferController,
              link: 'http://190.52.165.206:3000/just_drivers',
              label: 'Nombre del chofer',
              filtro: 'NAME',
            ),
          ),
          ModalRow(
            sideTitle: 'Ingrese Guarda',
            child: AsyncAutocomplete(
              icon: Icons.person,
              id: idGuarda,
              dataController: guardaController,
              link: 'http://190.52.165.206:3000/just_copilots',
              label: 'Nombre del guarda',
              filtro: 'NAME',
            ),
          ),
          ModalRow(
            sideTitle: 'Ingrese numero del coche',
            child: AsyncAutocomplete(
              icon: Icons.bus_alert,
              id: idCoche,
              dataController: cocheController,
              link: 'http://190.52.165.206:3000/vehicles',
              label: 'Numero de coche',
              filtro: 'NUMBER',
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
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/edit_travels'));
      requestPost.bodyFields = {
        'id': idViaje,
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
    print(lista);
    for (var i in lista) {
      if (i.isEmpty) return false;
      break;
    }
    return true;
  }
}
