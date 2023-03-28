import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

import '../widgets/modal_agregar_chofer.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Buscar', icon: Icon(Icons.search)),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    direction: Axis.horizontal,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const ModalAgregarChofer();
                              });
                        },
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.edit,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(showCheckboxColumn: true, columns: const [
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
                  ], rows: [
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('129')),
                          DataCell(Text('Guarda')),
                          DataCell(Text('Super Mario')),
                          DataCell(Text('4.700.788')),
                          DataCell(Text('1244')),
                          DataCell(Text('2000/03/03')),
                          DataCell(Text('Casado')),
                          DataCell(Text('Reino champinon')),
                          DataCell(Text('0998654345')),
                          DataCell(Text('Rambo')),
                          DataCell(Text('2023/03/27'))
                        ]),
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('137')),
                          DataCell(Text('Chofer')),
                          DataCell(Text('Ezequiel Pereira')),
                          DataCell(Text('5.101.788')),
                          DataCell(Text('1344')),
                          DataCell(Text('2000/03/03')),
                          DataCell(Text('Soltero')),
                          DataCell(Text('Pasp Pucu')),
                          DataCell(Text('0994521491')),
                          DataCell(Text('Calixto')),
                          DataCell(Text('2023/03/27'))
                        ]),
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('145')),
                          DataCell(Text('Chofer')),
                          DataCell(Text('Carl Johnson')),
                          DataCell(Text('7.500.788')),
                          DataCell(Text('4567')),
                          DataCell(Text('2000/03/03')),
                          DataCell(Text('Soltero')),
                          DataCell(Text('Grove Street')),
                          DataCell(Text('0995524491')),
                          DataCell(Text('Jasinto')),
                          DataCell(Text('2023/03/27'))
                        ])
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
