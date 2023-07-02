import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_number_picker.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
import 'package:horarios_web/widgets/custom/fields/modal_row.dart';
import 'package:horarios_web/widgets/pdf/report.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ModalGeneradorReporte extends StatefulWidget {
  const ModalGeneradorReporte(
      {super.key,
      required this.userId,
      required this.travels,
      required this.fecha});
  final int userId;
  final List<Group> travels;
  final String fecha;
  @override
  State<ModalGeneradorReporte> createState() => _ModalGeneradorReporteState();
}

class _ModalGeneradorReporteState extends State<ModalGeneradorReporte> {
  List<Empresa> listEmpresas = [];
  int reportId = 0;
  //controladores
  TextEditingController fechaController = TextEditingController();
  TextEditingController empresaController = TextEditingController();
  TextEditingController izquierdaController = TextEditingController();
  TextEditingController derechaController = TextEditingController();
  TextEditingController ancho = TextEditingController(text: '21');
  TextEditingController alto = TextEditingController(text: '33');
  TextEditingController mTop = TextEditingController(text: '2');
  TextEditingController mBottom = TextEditingController(text: '2');
  TextEditingController mLeft = TextEditingController(text: '2');
  TextEditingController mRight = TextEditingController(text: '2');
  TextEditingController tamanio = TextEditingController(text: '5');
  @override
  void initState() {
    super.initState();
    obtenerEmpresas();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Generar reporte',
        content: [
          Row(
            children: [
              CustomNumberPicker(
                textController: TextEditingController(),
                hint: 'valor',
                max: 50,
              ),
              const Divider(
                indent: 8,
              ),
              CustomNumberPicker(
                  max: 50,
                  textController: TextEditingController(),
                  hint: 'valor'),
              const Divider(
                indent: 8,
              ),
              CustomNumberPicker(
                  max: 50,
                  textController: TextEditingController(),
                  hint: 'valor'),
              const Divider(
                indent: 8,
              ),
              CustomNumberPicker(
                  max: 50,
                  textController: TextEditingController(),
                  hint: 'valor')
            ],
          ),
          ModalRow(
              sideTitle: 'Empresa',
              child: AsyncAutocomplete(
                  dataController: empresaController,
                  link: 'http://190.52.165.206:3000/companies',
                  label: 'Empresa',
                  filtro: 'NAME')),
          ModalRow(
              sideTitle: 'Ancho',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: ancho,
                  hint: 'Ancho de la hoja')),
          ModalRow(
              sideTitle: 'Alto',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: alto,
                  hint: 'Alto de la hoja')),
          ModalRow(
              sideTitle: 'Tamaño de letra',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: tamanio,
                  hint: 'Tamaño del texto')),
          ModalRow(
              sideTitle: 'Margen superior',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: mTop,
                  hint: 'Margen arriba')),
          ModalRow(
              sideTitle: 'Margen inferior',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: mBottom,
                  hint: 'Margen abajo')),
          ModalRow(
              sideTitle: 'Margen izquierdo',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: mLeft,
                  hint: 'Margen izquierda')),
          ModalRow(
              sideTitle: 'Margen derecho',
              child: CustomTextField(
                  lenght: 2,
                  numeric: true,
                  textController: mRight,
                  hint: 'Margen derecha')),
        ]);
  }

  void onAccept() async {
    var reporte = Report(widget.travels, reportId, fechaController.text,
        int.tryParse(empresaController.text)!, widget.userId, listEmpresas,
        ancho: int.tryParse(ancho.text)!,
        alto: int.tryParse(alto.text)!,
        texto: int.tryParse(tamanio.text)!,
        margenes: [
          double.tryParse(mTop.text)!,
          double.tryParse(mBottom.text)!,
          double.tryParse(mLeft.text)!,
          double.tryParse(mRight.text)!
        ]);
    reporte
        .generate(context, [izquierdaController.text, derechaController.text]);

    //API---------------------------------------------------
    List reportes = await fetchReports();
    if (reportes.isEmpty) {
      int idVal = await fetchMaxReportId() + 1;
      await postReport(idVal);
    } else {
      await updateReport();
    }
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> updateReport() async {
    var request = http.Request(
        'POST', Uri.parse('http://190.52.165.206:3000/reports_update'));
    request.bodyFields = {
      'date': widget.fecha,
      'time': horaString(DateTime.now()),
      'user': widget.userId.toString(),
      'empre': empresaController.text
    };

    await request.send();
  }

  Future<List> fetchReports() async {
    var request = http.Request('GET',
        Uri.parse('http://190.52.165.206:3000/reports?fecha=${widget.fecha}'));
    //send request
    http.StreamedResponse response = await request.send();
    //convert
    var data = await http.Response.fromStream(response);
    //convert received data to list
    List jsonResponse = json.decode(data.body);
    return jsonResponse;
  }

  Future<void> postReport(int id) async {
    var request = http.Request(
        'POST', Uri.parse('http://190.52.165.206:3000/reports_add'));
    request.bodyFields = {
      'id': id.toString(),
      'date': widget.fecha,
      'time': horaString(DateTime.now()),
      'user': widget.userId.toString(),
      'empre': empresaController.text
    };

    await request.send();
  }

  Future<int> fetchMaxReportId() async {
    var request = http.Request(
        'GET', Uri.parse('http://190.52.165.206:3000/max_reports_id'));
    request.bodyFields = {};

    http.StreamedResponse response = await request.send();
    var data = await http.Response.fromStream(response);
    List jsonResponse = json.decode(data.body);
    int valor = jsonResponse.first["MAX"];
    return valor;
  }

  Future fetchTravelsByGroup() async {
    final response = await http
        .get(Uri.parse('http://190.52.165.206:3000/travels_by_group'));
    reportId = await maxId();
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var element in jsonData) {
        List travelList = element['TRAVELS'];
        widget.travels
            .add(Group(element['ID'], element['NAME'].toString(), travelList));
      }
    } else {
      throw Exception('Fallo al obtener viajes por grupos');
    }
  }

  Future obtenerEmpresas() async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/companies'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      listEmpresas = data
          .map((registro) => Empresa(registro['ID'], registro['NAME']))
          .toList();
      return listEmpresas;
    } else {
      throw Exception('Error al obtener registros');
    }
  }

  Future maxId() async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/max_reports_id'));
    int idMax = json.decode(response.body)[0]['MAX'];
    return idMax + 1;
  }

  String horaString(DateTime data) {
    DateFormat formatter = DateFormat.Hm();
    String formattedTime = formatter.format(data);
    return formattedTime;
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
}
