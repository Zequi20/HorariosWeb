import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/lists/custom_list_view.dart';
import 'package:horarios_web/widgets/modals/generador/modal_generar_reporte.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

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
  var timeController = TextEditingController(
      text: '${DateFormat.Hm().format(DateTime.now())}:00');
  //colores
  var verticalController = ScrollController();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var colorBlanco = Colors.white;
//varios

  var fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  bool childUpdate = false;
  List<Group> travels = [];
  List<Empresa> empresasList = [];
  int dropDownValue = 0;
  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );
  @override
  void initState() {
    super.initState();
    fetchTravelsByGroup();
  }

  Future<List<Empresa>> obtenerEmpresas() async {
    List<Empresa> listaEmpresas = [];
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/companies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      listaEmpresas = data
          .map((registro) => Empresa(registro['ID'], registro['NAME']))
          .toList();
      return listaEmpresas;
    } else {
      throw Exception('Error al obtener registros');
    }
  }

  Future fetchAll() async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/max_reports_id'));
    int idMax = json.decode(response.body)[0]['MAX'];
    return idMax + 1;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FutureBuilder(
          future: fetchTravelsByGroup(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextButton.icon(
                  style: ButtonStyle(
                      side: MaterialStatePropertyAll(BorderSide(
                        color: colorBlanco,
                      )),
                      backgroundColor:
                          MaterialStatePropertyAll(gradPrincipalColor)),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ModalGeneradorReporte(userId: widget.userId!);
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
              return const Text('Cargando...');
            }
          }),
      body: FutureBuilder(
          future: fetchTravelsByGroup(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              travels = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child:
                    CustomListView(list: travels, updateParent: updateParent),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            }
          }),
      bottomNavigationBar: BottomAppBar(
        height: 40,
        color: gradPrincipalColor,
      ),
    );
  }

  void updateParent() {
    setState(() {
      childUpdate = true;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
