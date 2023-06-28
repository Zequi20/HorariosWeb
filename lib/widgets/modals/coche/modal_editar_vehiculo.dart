import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalEditarVehiculo extends StatefulWidget {
  const ModalEditarVehiculo({
    super.key,
    this.userId = 0,
    required this.rowId,
    required this.nroController,
    required this.tipoController,
    required this.descripcionController,
    required this.matriculaController,
    required this.asientosController,
  });
  final int? userId;
  final int rowId;
  final String nroController;
  final String tipoController;
  final String descripcionController;
  final String matriculaController;
  final String asientosController;

  @override
  State<ModalEditarVehiculo> createState() => _ModalEditarVehiculoState();
}

class _ModalEditarVehiculoState extends State<ModalEditarVehiculo> {
  String tipoValue = 'Chofer';
  String estadoValue = 'Soltero';
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;

  var nroController = TextEditingController();
  var tipoController = TextEditingController();
  var descripcionController = TextEditingController();
  var matriculaController = TextEditingController();
  var asientosController = TextEditingController();
  var usuarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nroController.text = widget.nroController;
    tipoController.text = widget.tipoController;
    descripcionController.text = widget.descripcionController;
    matriculaController.text = widget.matriculaController;
    asientosController.text = widget.asientosController;
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Agregar Coche',
        content: [
          ModalRow(
              sideTitle: 'Numero',
              child: CustomTextField(
                  numeric: true,
                  textController: nroController,
                  hint: 'Numero de coche')),
          ModalRow(
              sideTitle: 'Matricula',
              child: CustomTextField(
                  textController: matriculaController,
                  hint: 'Simbolos de matricula')),
          ModalRow(
              sideTitle: 'Tipo',
              child: CustomTextField(
                  textController: tipoController, hint: 'Tipo de coche')),
          ModalRow(
              sideTitle: 'Asientos',
              child: CustomTextField(
                  numeric: true,
                  textController: asientosController,
                  hint: 'Cantidad de asientos')),
          ModalRow(
              sideTitle: 'Descripcion (opcional)',
              child: CustomTextField(
                  textController: descripcionController,
                  hint: 'Descripcion de coche')),
        ]);
  }

  void onAccept() async {
    if (validateFields([
      nroController.text,
      tipoController.text,
    ])) {
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/edit_vehicles'));

      requestPost.bodyFields = {
        'id': widget.rowId.toString(),
        'number': nroController.text,
        'type': tipoController.text,
        'description': descripcionController.text,
        'license_plate': matriculaController.text,
        'seats': asientosController.text,
        'id_user': widget.userId.toString()
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
