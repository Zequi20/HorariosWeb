import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_stat.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key, this.userId = 0, this.userName = ''});
  final int? userId;
  final String? userName;
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with AutomaticKeepAliveClientMixin {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;

  Future<List<Stat>> fetchStats() async {
    List<Stat> estadisticas = [];
    estadisticas.add(await getStat(
        'count_vehicles',
        'Coches',
        const Icon(
          Icons.bus_alert,
          size: 42,
          color: Colors.white,
        )));
    estadisticas.add(await getStat(
        'count_reports',
        'Reportes',
        const Icon(
          Icons.picture_as_pdf,
          size: 42,
          color: Colors.white,
        )));
    estadisticas.add(await getStat(
        'count_drivers',
        'Choferes',
        const Icon(
          Icons.person_2,
          size: 42,
          color: Colors.white,
        )));
    estadisticas.add(await getStat(
        'count_guardas',
        'Guardas',
        const Icon(
          Icons.person,
          size: 42,
          color: Colors.white,
        )));
    estadisticas.add(await getStat(
        'count_groups',
        'Grupos',
        const Icon(
          Icons.map,
          size: 42,
          color: Colors.white,
        )));
    return estadisticas;
  }

  Future<Stat> getStat(String route, String element, Icon icon) async {
    var cantidad =
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/$route'));

    http.StreamedResponse responseStream = await cantidad.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonBody = json.decode(response.body);
    return Stat(icon, '${jsonBody.first['COUNT']} $element');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: FutureBuilder(
          future: fetchStats(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Stat> datos = snapshot.data!;
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Bienvenido ${widget.userName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: gradPrincipalColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                    ),
                    itemCount: datos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(2, 1))
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: gradPrincipalColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datos[index].icono,
                              const Divider(
                                color: Colors.transparent,
                                height: 4,
                              ),
                              Text(
                                datos[index].dato,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
