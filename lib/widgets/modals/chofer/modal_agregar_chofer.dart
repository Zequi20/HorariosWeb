import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/custom_date_picker.dart';
import 'package:horarios_web/widgets/custom/fields/custom_drop_drown.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ModalAgregarChofer extends StatefulWidget {
  const ModalAgregarChofer({super.key, this.userId = 0});
  final int? userId;
  @override
  State<ModalAgregarChofer> createState() => _ModalAgregarChoferState();
}

class _ModalAgregarChoferState extends State<ModalAgregarChofer> {
  var estadoController = TextEditingController(text: 'S');
  var tipoController = TextEditingController(text: 'C');
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  var fechaNacController = TextEditingController();
  var fechaAltaController = TextEditingController();
  var codigoController = TextEditingController();
  var nombreController = TextEditingController();
  var documentoController = TextEditingController();
  var registroController = TextEditingController();
  var direccionController = TextEditingController();
  var telefonoController = TextEditingController();
  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Agregar Chofer o Guarda',
        content: [
          ModalRow(
              sideTitle: 'Codigo',
              child: CustomTextField(
                  icon: Icons.numbers,
                  numeric: true,
                  lenght: 10,
                  textController: codigoController,
                  hint: 'Ingresar codigo')),
          ModalRow(
              sideTitle: 'Nombre',
              child: CustomTextField(
                lenght: 50,
                textController: nombreController,
                hint: 'Ingresar nombre',
              )),
          ModalRow(
              sideTitle: 'Telefono',
              child: CustomTextField(
                  icon: Icons.phone,
                  numeric: true,
                  lenght: 12,
                  textController: telefonoController,
                  hint: 'Ingrese numero de telefono')),
          ModalRow(
              sideTitle: 'Documento',
              child: CustomTextField(
                  icon: Icons.card_membership,
                  lenght: 12,
                  textController: documentoController,
                  hint: 'Ingrese numero de documento')),
          ModalRow(
              sideTitle: 'Registro',
              child: CustomTextField(
                  lenght: 12,
                  textController: registroController,
                  hint: 'Ingrese numero de registro')),
          ModalRow(
              sideTitle: 'Direccion',
              child: CustomTextField(
                  icon: Icons.location_on,
                  lenght: 50,
                  textController: direccionController,
                  hint: 'Ingrese direccion')),
          ModalRow(
              sideTitle: 'Nacimiento',
              child: CustomDatePicker(
                  fechaControlador: fechaNacController,
                  title: 'Fecha nacimiento')),
          ModalRow(
              sideTitle: 'Alta',
              child: CustomDatePicker(
                  fechaControlador: fechaAltaController, title: 'Fecha alta')),
          ModalRow(
              sideTitle: 'Tipo',
              child: CustomDropDrown(
                  dataController: tipoController,
                  label: 'Guarda o Chofer?',
                  options: const ['Chofer', 'Guarda'])),
          ModalRow(
              sideTitle: 'Estado',
              child: CustomDropDrown(
                  dataController: estadoController,
                  label: 'Soltero o Casado?',
                  options: const ['Soltero', 'Casado']))
        ]);
  }

  void onAccept() async {
    if (validateFields([
      nombreController.text,
      documentoController.text,
      codigoController.text,
      fechaAltaController.text,
      fechaNacController.text
    ])) {
      DateFormat formatoBD = DateFormat('yyyy-MM-dd');
      final response = await http
          .get(Uri.parse('http://190.52.165.206:3000/max_drivers_id'));
      int idMax = json.decode(response.body)[0]['MAX'];

      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/add_drivers'));

      idMax += 1;
      List<int> nac = fechaNacController.text
          .split('/')
          .map((e) => int.tryParse(e))
          .toList()
          .cast();
      List<int> alta = fechaAltaController.text
          .split('/')
          .map((e) => int.tryParse(e))
          .toList()
          .cast();
      requestPost.bodyFields = {
        'idkk': idMax.toString(),
        'codigo': codigoController.text,
        'nombre': nombreController.text,
        'documento': documentoController.text,
        'registro': registroController.text,
        'direccion': direccionController.text,
        'telefono': telefonoController.text,
        'fecha_nacimiento': formatoBD.format(DateTime(nac[2], nac[1], nac[0])),
        'fecha_alta': formatoBD.format(DateTime(alta[2], alta[1], alta[0])),
        'tipo': tipoController.text,
        'estado': estadoController.text,
        'id_usuario': widget.userId.toString()
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

  bool validateFields(List<String> lista) {
    for (var i in lista) {
      if (i.isEmpty) return false;
      break;
    }
    return true;
  }
}
