import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:http/http.dart' as http;

class ModalEditarGrupo extends StatefulWidget {
  const ModalEditarGrupo(
      {super.key,
      this.userId = 0,
      required this.id,
      required this.nombreController,
      required this.empresa,
      required this.descripcionController,
      required this.kmController});

  final int? userId;
  final int id;
  final String nombreController;
  final List<String> empresa;
  final String descripcionController;
  final String kmController;
  @override
  State<ModalEditarGrupo> createState() => _ModalEditarGrupoState();
}

class _ModalEditarGrupoState extends State<ModalEditarGrupo> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;

  var nombreController = TextEditingController();
  var descripcionController = TextEditingController();
  var kmController = TextEditingController();
  var empresaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.nombreController;
    descripcionController.text = widget.descripcionController;
    kmController.text = widget.kmController;
    empresaController.text = widget.empresa[1];
  }

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
                id: widget.empresa[0],
                link: 'http://190.52.165.206:3000/companies',
                label: 'Empresa',
                filtro: 'NAME',
                icon: Icons.work,
                setUpAndDown: (bool value) {},
              )),
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

  void onAccept() async {
    if (nombreController.text.isNotEmpty) {
      var requestPost = http.Request(
          'POST', Uri.parse('http://190.52.165.206:3000/edit_groups'));

      requestPost.bodyFields = {
        'id': widget.id.toString(),
        'name': nombreController.text,
        'company': empresaController.text,
        'description': descripcionController.text,
        'km': '0',
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
                  content: const Text('Operacion realizada con exito :)'),
                  actions: [
                    TextButton(
                      autofocus: true,
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
                  content: const Text('Algo ha salido mal :('),
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
  }
}
