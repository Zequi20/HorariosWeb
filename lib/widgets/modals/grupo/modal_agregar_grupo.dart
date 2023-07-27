import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalAgregarGrupo extends StatefulWidget {
  const ModalAgregarGrupo({super.key, this.userId = 0});
  final int? userId;
  @override
  State<ModalAgregarGrupo> createState() => _ModalAgregarGrupoState();
}

class _ModalAgregarGrupoState extends State<ModalAgregarGrupo> {
  //colores
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  //controladores de textos
  var nombreController = TextEditingController();
  var descripcionController = TextEditingController();
  var empresaController = TextEditingController();
  var kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Agregar Grupo',
        content: [
          ModalRow(
              sideTitle: 'Nombre',
              child: CustomTextField(
                  textController: nombreController, hint: 'Nombre de grupo')),
          ModalRow(
              sideTitle: 'Descripcion',
              child: CustomTextField(
                  icon: Icons.note_outlined,
                  textController: descripcionController,
                  hint: 'Descripcion de grupo')),
          ModalRow(
              sideTitle: 'Empresa',
              child: AsyncAutocomplete(
                dataController: empresaController,
                link: 'http://190.52.165.206:3000/companies',
                label: 'Empresa',
                filtro: 'NAME',
                icon: Icons.work,
              )),
        ]);
  }

  void onAccept() async {
    if (nombreController.text.isNotEmpty) {
      final response =
          await http.get(Uri.parse('http://190.52.165.206:3000/max_groups_id'));
      int idMax = json.decode(response.body)[0]['MAX'];
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/add_groups'));
      idMax += 1;
      requestPost.bodyFields = {
        'id': idMax.toString(),
        'name': nombreController.text,
        'company': empresaController.text,
        'description': descripcionController.text,
        'km': '0',
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
}
