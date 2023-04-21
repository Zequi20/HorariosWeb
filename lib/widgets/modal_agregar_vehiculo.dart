import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class ModalAgregarVehiculo extends StatefulWidget {
  const ModalAgregarVehiculo({super.key});

  @override
  State<ModalAgregarVehiculo> createState() => _ModalAgregarVehiculoState();
}

class _ModalAgregarVehiculoState extends State<ModalAgregarVehiculo> {
  String tipoValue = 'G8';
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  var fechaNacController = TextEditingController();
  var fechaAltaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var dropTipo = DropdownButtonFormField(
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
        ),
        value: tipoValue,
        items: const [
          DropdownMenuItem(
            value: 'G7',
            child: Text('G7'),
          ),
          DropdownMenuItem(
            value: 'G8',
            child: Text('G8'),
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
        'Agregar Vehiculo',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Row(children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tipo'),
                ),
              ),
              Expanded(
                flex: 2,
                child: dropTipo,
              )
            ]),
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
                const Expanded(child: Text('Numero')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
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
                const Expanded(
                  child: Text('Descripcion'),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Ingrese una descripcion'),
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
                const Expanded(child: Text('Nro de asientos')),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Ingrese cantidad de asientos',
                      filled: true,
                      fillColor: Colors.white,
                    ),
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
