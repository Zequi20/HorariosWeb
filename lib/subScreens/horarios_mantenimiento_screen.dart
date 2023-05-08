import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
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
        future: getRows(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
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
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: const Text('algo'),
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(label: Text('Nombre')),
                              ],
                              rows: const [
                                DataRow(cells: [DataCell(Text('KAKO'))])
                              ],
                            )
                          ],
                        ),
                      ],
                    ))
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

  Future<List<String>> getRows() async {
    empresas.clear();
    List<String> retorno = [];
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    var request =
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/GROUPS'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);
    for (var element in jsonResponse) {
      retorno.add(element['NAME'].toString());
    }

    return retorno;
  }

  @override
  bool get wantKeepAlive => true;
}
