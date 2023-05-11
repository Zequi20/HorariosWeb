import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ModalAgregarChofer extends StatefulWidget {
  const ModalAgregarChofer({super.key, this.userId = 0});
  final int? userId;
  @override
  State<ModalAgregarChofer> createState() => _ModalAgregarChoferState();
}

class _ModalAgregarChoferState extends State<ModalAgregarChofer> {
  String tipoValue = 'Chofer';
  String estadoValue = 'Soltero';
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
  Widget build(BuildContext context) {
    var dropEstadoCivil = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
          value: estadoValue,
          items: const [
            DropdownMenuItem(
              value: 'Soltero',
              child: Text('Soltero'),
            ),
            DropdownMenuItem(
              value: 'Casado',
              child: Text('Casado'),
            )
          ],
          onChanged: (value) {
            setState(() {
              estadoValue = value!;
            });
          }),
    );
    var dropTipo = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
          ),
          value: tipoValue,
          items: const [
            DropdownMenuItem(
              value: 'Chofer',
              child: Text('Chofer'),
            ),
            DropdownMenuItem(
              value: 'Guarda',
              child: Text('Guarda'),
            )
          ],
          onChanged: (value) {
            setState(() {
              tipoValue = value!;
            });
          }),
    );
    return AlertDialog(
      actions: [
        FilledButton.icon(
            onPressed: () async {
              if (nombreController.text.isNotEmpty &&
                  documentoController.text.isNotEmpty &&
                  registroController.text.isNotEmpty &&
                  direccionController.text.isNotEmpty &&
                  telefonoController.text.isNotEmpty &&
                  codigoController.text.isNotEmpty &&
                  fechaAltaController.text.isNotEmpty &&
                  fechaNacController.text.isNotEmpty) {
                final response = await http.get(
                    Uri.parse('http://190.52.165.206:3000/max_drivers_id'));
                int idMax = json.decode(response.body)[0]['MAX'];

                var requestPost = http.Request('POST',
                    Uri.parse('http://190.52.165.206:3000/add_drivers'));

                idMax += 1;
                requestPost.bodyFields = {
                  'idkk': idMax.toString(),
                  'codigo': codigoController.text,
                  'nombre': nombreController.text,
                  'documento': documentoController.text,
                  'registro': registroController.text,
                  'direccion': direccionController.text,
                  'telefono': telefonoController.text,
                  'fecha_nacimiento': fechaNacController.text,
                  'fecha_alta': fechaAltaController.text,
                  'tipo': tipoValue[0],
                  'estado': estadoValue[0],
                  'id_usuario': widget.userId.toString()
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
        'Agregar Chofer/Guarda',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Text('Codigo')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 10,
                    controller: codigoController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese el codigo',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Nombre')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 50,
                    controller: nombreController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese un nombre',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Telefono')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 12,
                    controller: telefonoController,
                    decoration: const InputDecoration(
                        hintText: 'Ingrese nro de telefono',
                        filled: true,
                        fillColor: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Documento'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                    ],
                    maxLength: 12,
                    controller: documentoController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese nro de documento'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Registro'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 12,
                    controller: registroController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese nro de registro'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Direccion')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    maxLength: 50,
                    controller: direccionController,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese direccion',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Fecha de nacimiento'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    onTap: () async {
                      fechaNacController.text = await showDatePicker(
                        cancelText: 'Cancelar',
                        confirmText: 'Aceptar',
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                      primary: principalColor,
                                      secondary: Colors.white)),
                              child: DatePickerDialog(
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000, 1, 1),
                                lastDate: DateTime.now(),
                              ));
                        },
                      ).then((value) {
                        if (value != null) {
                          return DateFormat('yyyy-MM-dd').format(value);
                        } else {
                          return fechaNacController.text;
                        }
                      });
                    },
                    controller: fechaNacController,
                    decoration: const InputDecoration(
                      hintText: 'Seleccionar fecha',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 16,
              color: Colors.transparent,
            ),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Fecha de alta'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: fechaAltaController,
                    onTap: () async {
                      fechaAltaController.text = await showDatePicker(
                        cancelText: 'Cancelar',
                        confirmText: 'Aceptar',
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000, 1, 1),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                      primary: principalColor,
                                      secondary: Colors.white)),
                              child: DatePickerDialog(
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000, 1, 1),
                                lastDate: DateTime.now(),
                              ));
                        },
                      ).then((value) {
                        if (value != null) {
                          return DateFormat('yyyy-MM-dd').format(value);
                        } else {
                          return fechaAltaController.text;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Seleccionar fecha',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Tipo'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Estado'),
                  ),
                )
              ],
            ),
            Row(children: [
              Expanded(
                child: dropTipo,
              ),
              Expanded(
                child: dropEstadoCivil,
              )
            ]),
          ],
        )),
      ),
    );
  }
}
