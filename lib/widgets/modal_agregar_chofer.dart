import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModalAgregarChofer extends StatefulWidget {
  const ModalAgregarChofer({super.key});

  @override
  State<ModalAgregarChofer> createState() => _ModalAgregarChoferState();
}

class _ModalAgregarChoferState extends State<ModalAgregarChofer> {
  String tipoValue = 'Chofer';
  String estadoValue = 'Soltero';
  var resaltadoColor = Colors.orange;
  var fechaNacController = TextEditingController();
  var fechaAltaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var dropEstadoCivil = DropdownButtonFormField(
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
        });
    var dropTipo = DropdownButtonFormField(
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
        });
    return AlertDialog(
      actions: [
        FilledButton.icon(
            onPressed: () {
              setState(() {});
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
                const Expanded(
                  child: Text('Documento'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
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
                                      primary: resaltadoColor,
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
                                      primary: resaltadoColor,
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
