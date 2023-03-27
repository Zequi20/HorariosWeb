import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

import '../widgets/modal_agregar.dart';

class ScreenChoferes extends StatefulWidget {
  const ScreenChoferes({super.key});

  @override
  State<ScreenChoferes> createState() => _ScreenChoferesState();
}

class _ScreenChoferesState extends State<ScreenChoferes>
    with AutomaticKeepAliveClientMixin {
  DateTime curDate = DateTime.now();
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Buscar:'),
              ),
              Expanded(child: TextFormField())
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(columns: const [
                    DataColumn(label: Text('Codigo')),
                    DataColumn(label: Text('Tipo')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Documento')),
                    DataColumn(label: Text('Registro')),
                    DataColumn(label: Text('Nacimiento')),
                    DataColumn(label: Text('Estado Civil')),
                    DataColumn(label: Text('Direccion')),
                    DataColumn(label: Text('Telefono')),
                    DataColumn(label: Text('Usuario')),
                    DataColumn(label: Text('Alta'))
                  ], rows: const [
                    DataRow(cells: [
                      DataCell(Text('134')),
                      DataCell(Text('Chofer')),
                      DataCell(Text('Ezequiel Pereira')),
                      DataCell(Text('5.101.788')),
                      DataCell(Text('1244')),
                      DataCell(Text('2000/03/03')),
                      DataCell(Text('Soltero')),
                      DataCell(Text('Pasp Pucu')),
                      DataCell(Text('0994521491')),
                      DataCell(Text('Calixto')),
                      DataCell(Text('2023/03/27'))
                    ])
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Wrap(
        spacing: 8,
        direction: Axis.vertical,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ModalAgregar();
                  });
            },
            child: Icon(
              Icons.add,
              color: resaltadoColor,
              size: 30,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            child: Icon(
              Icons.edit,
              color: resaltadoColor,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            child: Icon(
              Icons.delete,
              color: resaltadoColor,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
