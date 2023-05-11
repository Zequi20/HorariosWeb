import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
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
  //colores
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var colorBlanco = Colors.white;
//varios
  StreamController groupController = StreamController<List<Group>>();
  List<Group> travels = [];
  @override
  void initState() {
    super.initState();
    fetchTravelsByGroup();
  }

  @override
  void dispose() {
    groupController.close();
    super.dispose();
  }

  void fetchTravelsByGroup() async {
    travels.clear();
    final response = await http
        .get(Uri.parse('http://190.52.165.206:3000/travels_by_group'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      for (var element in jsonData) {
        List travelList = element['TRAVELS'];
        travels.add(Group(
            element['ID'],
            element['NAME'].toString(),
            travelList
                .map((e) => DataRow(cells: [
                      DataCell(Text(e['DEPARTURE_TIME'])),
                      DataCell(Text(e['ARRIVAL_TIME'])),
                      DataCell(Text(e['VEHICLE'])),
                      DataCell(Text(e['DRIVER1'])),
                      DataCell(Text(e['DRIVER2'])),
                      DataCell(Text(e['NOTE'])),
                      DataCell(Text(e['KM'].toString())),
                    ]))
                .toList()));
      }

      groupController.sink.add(travels);
    } else {
      throw Exception('Fallo al obtener viajes por grupos');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: StreamBuilder(
            stream: groupController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Group> datos = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            height: 2,
                            color: colorBlanco,
                          ),
                      itemCount: datos.length,
                      itemBuilder: (context, index) => ExpansionTile(
                            iconColor: colorBlanco,
                            collapsedIconColor: colorBlanco,
                            collapsedTextColor: colorBlanco,
                            collapsedBackgroundColor: principalColor,
                            textColor: colorBlanco,
                            backgroundColor: principalColor,
                            title: Text(
                              datos[index].name,
                              textAlign: TextAlign.center,
                            ),
                            leading: Text('grupo ${datos[index].id}'),
                            children: [
                              Container(
                                color: colorBlanco,
                                child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('PARTIDA')),
                                      DataColumn(label: Text('LLEGADA')),
                                      DataColumn(label: Text('VEHICULO')),
                                      DataColumn(label: Text('CONDUCTOR')),
                                      DataColumn(label: Text('GUARDA')),
                                      DataColumn(label: Text('NOTA')),
                                      DataColumn(label: Text('KM')),
                                    ],
                                    rows: datos[index].data.isNotEmpty
                                        ? datos[index].data
                                        : []),
                              )
                            ],
                          )),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
