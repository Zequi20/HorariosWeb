import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/custom_date_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ModalExtraer extends StatefulWidget {
  const ModalExtraer({super.key, required this.fechaActual});
  final String fechaActual;
  @override
  State<ModalExtraer> createState() => _ModalExtraerState();
}

class _ModalExtraerState extends State<ModalExtraer> {
  TextEditingController fechaExtraccion = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy/MM/dd');
  @override
  void initState() {
    super.initState();
    fechaExtraccion.text = formatter.format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Extraer Viajes por fecha',
        content: [
          ModalRow(
              sideTitle: 'Ingrese horario de Partida',
              child: CustomDatePicker(
                  fechaControlador: fechaExtraccion,
                  title: 'Extraer de la fecha:'))
        ]);
  }

  Future onAccept() async {
    var requestPost = http.Request(
        'POST', Uri.parse('http://190.52.165.206:3000/duplicate_travels'));

    requestPost.bodyFields = {
      'begin': invertirFecha(widget.fechaActual),
      'end': invertirFecha(fechaExtraccion.text)
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
  }

  String invertirFecha(String fecha) {
    List<String> lista = fecha.split('/');
    return '${lista[2]}/${lista[1]}/${lista[0]}';
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
}
