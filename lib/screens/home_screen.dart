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
    estadisticas.add(
        await getStat('count_vehicles', 'Coches', const Icon(Icons.bus_alert)));
    estadisticas.add(await getStat(
        'count_reports', 'Reportes', const Icon(Icons.picture_as_pdf)));
    estadisticas.add(await getStat(
        'count_drivers', 'Conductores', const Icon(Icons.person_2)));
    estadisticas.add(
        await getStat('count_guardas', 'Guardas', const Icon(Icons.person)));
    estadisticas
        .add(await getStat('count_groups', 'Grupos', const Icon(Icons.map)));
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Bienvenido ${widget.userName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: fetchStats(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Stat> datos = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.8,
                          crossAxisCount: 2,
                        ),
                        itemCount: datos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              datos[index].icono,
                              Text(datos[index].dato)
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text('Cargando...');
                  }
                }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
