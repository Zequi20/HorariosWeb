import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/buttons/generate_report_button.dart';
import 'package:horarios_web/widgets/custom/fields/custom_date_picker.dart';
import 'package:horarios_web/widgets/custom/tables/view_table.dart';
import 'package:horarios_web/widgets/modals/viaje/modal_extraer_viajes.dart';
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
  var dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  @override
  void initState() {
    super.initState();
    dateController.addListener(() {
      setState(() {
        show = true;
      });
    });
  }

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
  List<Group> locura = [];
  List<Empresa> empresasList = [];
  int dropDownValue = 0;
  var defaultDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
  );

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

  Future<List<Group>> fetchTravelsByGroup(String fecha) async {
    List<Group> travels = [];
    var url = Uri.parse(
        'http://190.52.165.206:3000/travels_by_group?fecha=${dateFormaterString(fecha)}');
    var headers = {'Content-Type': 'application/json'};

    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      for (var element in jsonData) {
        List travelList = element['TRAVELS'];
        travels
            .add(Group(element['ID'], element['NAME'].toString(), travelList));
      }
    } else {
      msgBox('Error de red', 'Vuelva a intentarlo en unos momentos');
    }
    return travels;
  }

  bool checkEmptyTravel(List<Group> lista) {
    bool vacio = true;
    for (var element in lista) {
      if (element.travelsData.isNotEmpty) {
        vacio = false;
      }
    }
    return vacio;
  }

  bool show = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: fetchTravelsByGroup(dateController.text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FractionColumnWidth(1 / 20),
                    1: FractionColumnWidth(1 / 6),
                    2: FractionColumnWidth(1 / 6),
                    3: FractionColumnWidth(1 / 6),
                    4: FractionColumnWidth(1 / 20),
                    5: FractionColumnWidth(1 / 6),
                    6: FractionColumnWidth(1 / 20),
                  },
                  children: const [
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Salida',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Coche',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Conductor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Guarda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Retorno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nota',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Acciones',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )),
                    ])
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ViewTable(
                      grupos: snapshot.data!,
                      fecha: dateController.text,
                      updateParent: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
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
      bottomNavigationBar: ExcludeFocus(
        child: BottomAppBar(
            elevation: 8,
            padding: const EdgeInsets.all(4),
            height: 70,
            color: gradPrincipalColor,
            child: Row(
              children: [
                Expanded(
                    child: TextButton.icon(
                        style: ButtonStyle(
                            side: const MaterialStatePropertyAll(BorderSide(
                              color: Colors.white,
                            )),
                            backgroundColor:
                                MaterialStatePropertyAll(principalColor)),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return ModalExtraer(
                                    fechaActual: dateController.text);
                              });
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.sim_card_download_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Extraer Viajes',
                          style: TextStyle(color: colorBlanco),
                          textAlign: TextAlign.center,
                        ))),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Filtrar por fecha:',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: colorBlanco),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: CustomDatePicker(
                        fechaControlador: dateController,
                        title: 'Fecha de reporte')),
                Expanded(
                    child: GenerateReportButton(
                  fecha: dateFormaterString(dateController.text),
                  padding: 22,
                  userId: widget.userId!,
                  viajes: locura,
                ))
              ],
            )),
      ),
    );
  }

  Future<void> msgBox(String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                autofocus: true,
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  List<int> dateFormater(String inputDate) {
    List<String> numbers = inputDate.split('/');
    return [
      int.parse(numbers[0]),
      int.parse(numbers[1]),
      int.parse(numbers[2])
    ];
  }

  String dateFormaterString(String inputDate) {
    List<String> numbers = inputDate.split('/');
    return '${numbers[2]}-${numbers[1]}-${numbers[0]}';
  }

  @override
  bool get wantKeepAlive => true;
}
