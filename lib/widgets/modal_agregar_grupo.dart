import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:http/http.dart' as http;

class ModalAgregarGrupo extends StatefulWidget {
  const ModalAgregarGrupo({super.key, this.userId = 0});
  final int? userId;
  @override
  State<ModalAgregarGrupo> createState() => _ModalAgregarGrupoState();
}

class _ModalAgregarGrupoState extends State<ModalAgregarGrupo> {
  int empresaValue = 0;
  late List<Empresa> listaEmpresas;

  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;

  var nombreController = TextEditingController();
  var descripcionController = TextEditingController();
  var kmController = TextEditingController();

  Future<List<Empresa>> obtenerEmpresas() async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/companies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      listaEmpresas = data
          .map((registro) => Empresa(registro['ID'], registro['NAME']))
          .toList();
      return listaEmpresas;
    } else {
      throw Exception('Error al obtener registros');
    }
  }

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
              if (nombreController.text.isNotEmpty &&
                  descripcionController.text.isNotEmpty &&
                  kmController.text.isNotEmpty) {
                final response = await http
                    .get(Uri.parse('http://190.52.165.206:3000/max_groups_id'));
                int idMax = json.decode(response.body)[0]['MAX'];

                var requestPost = http.Request(
                    'POST', Uri.parse('http://190.52.165.206:3000/add_groups'));

                idMax += 1;
                requestPost.bodyFields = {
                  'id': idMax.toString(),
                  'name': nombreController.text,
                  'company': empresaValue.toString(),
                  'description': descripcionController.text,
                  'km': kmController.text.trim().replaceAll('.', ''),
                  'id_user': widget.userId.toString()
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
      title: const Text(
        'Agregar Grupo',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Nombre')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 50,
                    controller: nombreController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese el nombre',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Empresa')),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: FutureBuilder(
                      future: obtenerEmpresas(),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  filled: true, fillColor: Colors.white),
                              value: empresaValue,
                              items: List.generate(
                                  listaEmpresas.length,
                                  (index) => DropdownMenuItem(
                                        value: listaEmpresas[index].id,
                                        child:
                                            Text(listaEmpresas[index].nombre),
                                      )),
                              onChanged: (int? value) {
                                setState(() {
                                  empresaValue = value!;
                                });
                              },
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 8,
              color: Colors.transparent,
            ),
            Row(
              children: [
                const Expanded(child: Text('Descripcion')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 50,
                    controller: descripcionController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese descripcion',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Km'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 12,
                    controller: kmController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese el Km'),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
