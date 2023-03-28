import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/modal_agregar_vehiculo.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class ScreenVehiculos extends StatefulWidget {
  const ScreenVehiculos({super.key});

  @override
  State<ScreenVehiculos> createState() => _ScreenVehiculosState();
}

class _ScreenVehiculosState extends State<ScreenVehiculos>
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
                                return const ModalAgregarVehiculo();
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
                    DataColumn(label: Text('Nro')),
                    DataColumn(label: Text('Tipo')),
                    DataColumn(label: Text('Descripcion')),
                    DataColumn(label: Text('Matricula')),
                    DataColumn(label: Text('Asientos')),
                    DataColumn(label: Text('Usuario')),
                  ], rows: [
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('129')),
                          DataCell(Text('670')),
                          DataCell(Text('G8')),
                          DataCell(Text('Con turbo y pinchos')),
                          DataCell(Text('1244')),
                          DataCell(Text('40')),
                          DataCell(Text('Pelopincho')),
                        ]),
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('124')),
                          DataCell(Text('470')),
                          DataCell(Text('G5')),
                          DataCell(Text('Con lanzallamas y bomba')),
                          DataCell(Text('1144')),
                          DataCell(Text('37')),
                          DataCell(Text('Leka')),
                        ]),
                    DataRow(
                        onSelectChanged: (value) {
                          setState(() {});
                        },
                        cells: const [
                          DataCell(Text('034')),
                          DataCell(Text('460')),
                          DataCell(Text('G9')),
                          DataCell(Text('Color rayo McQueen')),
                          DataCell(Text('1454')),
                          DataCell(Text('27')),
                          DataCell(Text('Leka')),
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
