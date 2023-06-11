import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/report.dart';
import 'package:horarios_web/widgets/tabla_grupos.dart';
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
  //campos de texto
  var izquierdaController = TextEditingController();
  var derechaController = TextEditingController();
  //colores
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var colorBlanco = Colors.white;
//varios
  bool childUpdate = false;
  List<Group> travels = [];
  @override
  void initState() {
    super.initState();
    fetchTravelsByGroup();
  }

  Future fetchTravelsByGroup() async {
    List<Group> travels = [];
    final response = await http
        .get(Uri.parse('http://190.52.165.206:3000/travels_by_group'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      for (var element in jsonData) {
        List travelList = element['TRAVELS'];
        travels
            .add(Group(element['ID'], element['NAME'].toString(), travelList));
      }
    } else {
      throw Exception('Fallo al obtener viajes por grupos');
    }
    return travels;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FutureBuilder(
            future: fetchTravelsByGroup(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(gradPrincipalColor)),
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog.fullscreen(
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      'Generador de reporte',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Comentario del lado derecho',
                                            filled: true,
                                            fillColor: Colors.white),
                                        maxLines: null,
                                        minLines: null,
                                        expands: true,
                                        controller: derechaController,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText:
                                                'Comentario del lado izquierdo',
                                            filled: true,
                                            fillColor: Colors.white),
                                        maxLines: null,
                                        minLines: null,
                                        expands: true,
                                        controller: izquierdaController,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(
                                        'Fecha e id etc',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextButton.icon(
                                              icon: Icon(
                                                Icons.arrow_back,
                                                color: resaltadoColor,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              label: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                            color:
                                                                resaltadoColor)),
                                                    child: Text(
                                                      'Cancelar',
                                                      style: TextStyle(
                                                          color:
                                                              resaltadoColor),
                                                    )),
                                              )),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton.icon(
                                            icon: Icon(
                                              Icons.picture_as_pdf,
                                              color: resaltadoColor,
                                            ),
                                            onPressed: () async {
                                              var reporte =
                                                  Report(snapshot.data);
                                              reporte.generate(context, [
                                                izquierdaController.text,
                                                derechaController.text
                                              ]);
                                            },
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5)),
                                                      border: Border.all(
                                                          color:
                                                              resaltadoColor)),
                                                  child: Text(
                                                    'Generar',
                                                    style: TextStyle(
                                                        color: resaltadoColor),
                                                  )),
                                            )),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.note_add,
                      color: Colors.white,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Generador de reporte',
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
              } else {
                return const CircularProgressIndicator(
                  color: Colors.red,
                );
              }
            }),
        body: FutureBuilder(
            future: fetchTravelsByGroup(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                travels = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            height: 3,
                            color: colorBlanco,
                          ),
                      itemCount: travels.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          collapsedShape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          iconColor: colorBlanco,
                          collapsedIconColor: colorBlanco,
                          collapsedTextColor: colorBlanco,
                          collapsedBackgroundColor: principalColor,
                          textColor: colorBlanco,
                          backgroundColor: gradPrincipalColor,
                          title: Text(
                            travels[index].name,
                            textAlign: TextAlign.center,
                          ),
                          leading: Text('grupo ${travels[index].id}'),
                          children: [
                            GroupTable(
                              travels: travels,
                              index: index,
                              updateParent: updateParent,
                            ),
                          ],
                        );
                      }),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              }
            }));
  }

  void updateParent() {
    setState(() {
      childUpdate = true;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
