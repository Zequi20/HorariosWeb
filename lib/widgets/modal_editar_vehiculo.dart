import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return AlertDialog(
      actions: [
        FilledButton.icon(
            onPressed: () async {
              if (nroController.text.isNotEmpty &&
                  tipoController.text.isNotEmpty &&
                  descripcionController.text.isNotEmpty &&
                  matriculaController.text.isNotEmpty &&
                  asientosController.text.isNotEmpty) {
                var requestPost = http.Request('POST',
                    Uri.parse('http://190.52.165.206:3000/edit_vehicles'));

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
              'Editar',
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
        'Agregar Vehiculo',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Nro')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 10,
                    controller: nroController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese el numero',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Tipo')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 50,
                    controller: tipoController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese el tipo',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Descripcion')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 12,
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
                  child: Text('Matricula'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 12,
                    controller: matriculaController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese la matricula'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Asientos'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 12,
                    controller: asientosController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese la cantidad de asientos'),
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
