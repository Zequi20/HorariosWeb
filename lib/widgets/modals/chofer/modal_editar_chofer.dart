import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/custom_date_picker.dart';
import 'package:horarios_web/widgets/custom/fields/custom_drop_drown.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/modal_row.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ModalEditarChofer extends StatefulWidget {
  const ModalEditarChofer(
      {super.key,
      this.userId = 0,
      required this.rowId,
      required this.fechaNac,
      required this.fechaAlta,
      required this.codigo,
      required this.nombre,
      required this.documento,
      required this.registro,
      required this.direccion,
      required this.telefono,
      required this.tipo,
      required this.estado});

  final int? userId;
  final int rowId;
  final String fechaNac;
  final String fechaAlta;
  final String codigo;
  final String nombre;
  final String documento;
  final String registro;
  final String direccion;
  final String telefono;
  final String tipo;
  final String estado;
  @override
  State<ModalEditarChofer> createState() => _ModalEditarChoferState();
}

class _ModalEditarChoferState extends State<ModalEditarChofer> {
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
  @override
  void initState() {
    super.initState();
    fechaNacController.text = widget.fechaNac;
    fechaAltaController.text = widget.fechaAlta;
    codigoController.text = widget.codigo;
    nombreController.text = widget.nombre;
    documentoController.text = widget.documento;
    registroController.text = widget.registro;
    direccionController.text = widget.direccion;
    telefonoController.text = widget.telefono;
    estadoController.text = widget.estado[0].toUpperCase();
    tipoController.text = widget.tipo[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Agregar Chofer o Guarda',
        content: [
          ModalRow(
              sideTitle: 'Codigo',
              child: CustomTextField(
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
                  lenght: 12,
                  textController: telefonoController,
                  hint: 'Ingrese numero de telefono')),
          ModalRow(
              sideTitle: 'Documento',
              child: CustomTextField(
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

  Future onAccept() async {
    if (validateFields([
      nombreController.text,
      documentoController.text,
      codigoController.text,
      fechaAltaController.text,
      fechaNacController.text
    ])) {
      DateFormat formatoBD = DateFormat('yyyy-MM-dd');
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/edit_drivers'));
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
        'id': widget.rowId.toString(),
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
}
