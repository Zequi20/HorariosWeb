import 'package:flutter/material.dart';

class ModalAgregar extends StatefulWidget {
  const ModalAgregar({super.key});

  @override
  State<ModalAgregar> createState() => _ModalAgregarState();
}

class _ModalAgregarState extends State<ModalAgregar> {
  String tipoValue = 'Chofer';
  String estadoValue = 'Soltero';
  @override
  Widget build(BuildContext context) {
    var dropEstadoCivil = DropdownButtonFormField(
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
      title: const Text(
        'Agregar Chofer/Guarda',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Nombre'),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Ingrese un nombre'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Documento'),
            ),
            TextFormField(
              decoration:
                  const InputDecoration(hintText: 'Ingrese nro de documento'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Registro'),
            ),
            TextFormField(
              decoration:
                  const InputDecoration(hintText: 'Ingrese nro de registro'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Direccion'),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Ingrese direccion'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Fecha de nacimiento'),
            ),
            TextFormField(
              readOnly: true,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Fecha de alta'),
            ),
            TextFormField(
              readOnly: true,
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
