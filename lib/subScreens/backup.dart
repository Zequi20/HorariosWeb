import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/travel_table.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HorariosMantenimiento extends StatefulWidget {
  const HorariosMantenimiento({super.key, this.userId = 0});
  final int? userId;

  @override
  State<HorariosMantenimiento> createState() => _HorariosMantenimientoState();
}

class _HorariosMantenimientoState extends State<HorariosMantenimiento>
    with AutomaticKeepAliveClientMixin {
  List<Empresa> empresas = [];
  int empresaValue = 0;
  late final Stream<List<Empresa>> _elementsStream;
  final _elementsStreamController = StreamController<List<Empresa>>();
  //var horizontalController = ScrollController();
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  void initState() {
    super.initState();
    _elementsStream = fetchElements().asStream();
    loadElements();
  }

  @override
  void dispose() {
    _elementsStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: getGroups(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Group> datos = snapshot.data;
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: const [
                            Text('ID'),
                            Divider(
                              height: 12,
                            ),
                            Text('1234')
                          ],
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: const [
                            Text('Fecha'),
                            Divider(
                              height: 12,
                            ),
                            Text('12-12-2022')
                          ],
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: const [
                            Text('Hora'),
                            Divider(
                              height: 12,
                            ),
                            Text('12:30')
                          ],
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: const [
                            Text('Usuario'),
                            Divider(
                              height: 12,
                            ),
                            Text('Pelao')
                          ],
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('Empresa'),
                            const Divider(
                              height: 12,
                            ),
                            StreamBuilder<List<Empresa>>(
                              stream: _elementsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Empresa>> snapshot) {
                                if (snapshot.hasData) {
                                  // Construcción del DropdownButton a partir de los elementos de la lista
                                  return DropdownButtonFormField<int>(
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    value: empresaValue,
                                    items: snapshot.data!.map((element) {
                                      return DropdownMenuItem<int>(
                                        value: element.id,
                                        child: Text(element.nombre),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        empresaValue = value!;
                                      }); // Manejo del cambio de valor seleccionado en el DropdownButton
                                    },
                                  );
                                } else {
                                  // Indicador de carga o estado inicial
                                  return const CircularProgressIndicator(
                                    color: Colors.red,
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Column(
                      children: List.generate(
                          datos.length,
                          (i) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        principalColor,
                                        gradPrincipalColor,
                                        principalColor
                                      ])),
                                  child: ExpansionTile(
                                      backgroundColor: Colors.transparent,
                                      collapsedBackgroundColor:
                                          Colors.transparent,
                                      collapsedTextColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      iconColor: Colors.white,
                                      textColor: Colors.white,
                                      title: Text(
                                        datos[i].name,
                                        textAlign: TextAlign.center,
                                      ),
                                      leading: Text(
                                        'GRUPO ${datos[i].id}',
                                        textAlign: TextAlign.left,
                                      ),
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TravelTable(
                                                    key: Key('$i'),
                                                    rows:
                                                        datos[i].data.isNotEmpty
                                                            ? datos[i].data
                                                            : datos[i].data,
                                                  ),
                                                )),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      )),
                                                  IconButton(
                                                      style:
                                                          const ButtonStyle(),
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              )),
                    )),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Stream<List<Empresa>> get elementsStream => _elementsStreamController.stream;

  void loadElements() async {
    try {
      final elements = await fetchElements();
      _elementsStreamController.add(elements);
    } catch (e) {
      _elementsStreamController.addError(e);
    }
  }

  Future<List<Empresa>> fetchElements() async {
    List<Empresa> lalista = [];
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/COMPANIES'));

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, devuelve la lista de elementos decodificada desde el JSON
      final decoded = json.decode(response.body);
      for (var element in decoded) {
        lalista.add(Empresa(element['ID'], element['NAME']));
      }
      return lalista;
    } else {
      // Si no es exitosa, lanza una excepción
      throw Exception('Fallo al obtener elementos');
    }
  }

  Future<List<Group>> getGroups() async {
    empresas.clear();
    List<Group> retorno = [];
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    var request = http.Request(
        'GET', Uri.parse('http://190.52.165.206:3000/TRAVELS_BY_GROUP'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);
    List<DataRow> row = [];
    row.clear();
    for (var element in jsonResponse) {
      List aux = element['TRAVELS'];

      for (var element in aux) {
        row.add(DataRow(cells: [
          DataCell(Text(element['DEPARTURE_TIME'])),
          DataCell(Text(element['VEHICLE'])),
          DataCell(Text(element['DRIVER1'])),
          DataCell(Text(element['DRIVER2'])),
          DataCell(Text(element['ARRIVAL_TIME'])),
          DataCell(Text(element['NOTE'])),
          DataCell(Text(element['KM'].toString())),
        ]));
      }

      retorno.add(Group(element['ID'], element['NAME'], row));
    }

    return retorno;
  }

  @override
  bool get wantKeepAlive => true;
}
