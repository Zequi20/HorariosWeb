import 'dart:convert';
import 'package:horarios_web/widgets/custom/controllers/custom_text_controller.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/containers/form_subsection.dart';
import 'package:horarios_web/widgets/custom/dialogs/custom_modal_dialog.dart';
import 'package:horarios_web/widgets/custom/fields/autocompletado.dart';
import 'package:horarios_web/widgets/custom/fields/custom_number_picker.dart';
import 'package:horarios_web/widgets/custom/containers/modal_row.dart';
import 'package:horarios_web/widgets/custom/fields/custom_text_field.dart';
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
  TextEditingController empresaController = TextEditingController(
      text: 'Empresa Guaireña de Transporte y Turismo SRL');
  CustomTextEditingController izquierdaController =
      CustomTextEditingController({
    r'\*(.*?)\*': const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  });
  CustomTextEditingController derechaController = CustomTextEditingController({
    r'\*(.*?)\*': const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  });
  TextEditingController ancho = TextEditingController(text: '21');
  TextEditingController alto = TextEditingController(text: '33');
  TextEditingController mTop = TextEditingController(text: '2');
  TextEditingController mBottom = TextEditingController(text: '2');
  TextEditingController mLeft = TextEditingController(text: '2');
  TextEditingController mRight = TextEditingController(text: '2');
  TextEditingController tamanio = TextEditingController(text: '8');
  @override
  void initState() {
    super.initState();
    obtenerEmpresas();
    verifyLocalStorageComments();
    izquierdaController.addListener(() {
      html.window.localStorage['cm1'] = izquierdaController.text;
    });
    derechaController.addListener(() {
      html.window.localStorage['cm2'] = derechaController.text;
    });
  }

  void verifyLocalStorageComments() {
    String? comentarioArriba = html.window.localStorage['cm1'];
    String? comentarioAbajo = html.window.localStorage['cm2'];
    if (comentarioArriba != null) {
      izquierdaController.text = comentarioArriba;
    }
    if (comentarioAbajo != null) {
      derechaController.text = comentarioAbajo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModalDialog(
        onAccept: onAccept,
        title: 'Generar reporte',
        content: [
          ModalRow(
              sideTitle: 'Margenes verticales',
              child: FormSubsection(
                childList: [
                  TitledWidget(
                      'Superior',
                      CustomNumberPicker(
                          icon: Icons.border_top,
                          initialValue: 15,
                          textController: mTop,
                          hint: 'margen superior',
                          max: 50)),
                  TitledWidget(
                      'Inferior',
                      CustomNumberPicker(
                          icon: Icons.border_bottom,
                          initialValue: 15,
                          textController: mBottom,
                          hint: 'margen inferior',
                          max: 50)),
                ],
              )),
          ModalRow(
              sideTitle: 'Margenes horizontales',
              child: FormSubsection(
                childList: [
                  TitledWidget(
                      'Izquierdo',
                      CustomNumberPicker(
                          icon: Icons.border_left,
                          initialValue: 15,
                          textController: mLeft,
                          hint: 'margen izquierdo',
                          max: 50)),
                  TitledWidget(
                      'Derecho',
                      CustomNumberPicker(
                          icon: Icons.border_right,
                          initialValue: 15,
                          textController: mRight,
                          hint: 'margen derecho',
                          max: 50)),
                ],
              )),
          ModalRow(
              sideTitle: 'Dimensiones (mm)',
              child: FormSubsection(
                childList: [
                  TitledWidget(
                      'Ancho',
                      CustomNumberPicker(
                          icon: Icons.width_normal,
                          initialValue: 216,
                          textController: ancho,
                          hint: 'ancho de pagina',
                          max: 500)),
                  TitledWidget(
                      'Alto',
                      CustomNumberPicker(
                          icon: Icons.height,
                          initialValue: 330,
                          textController: alto,
                          hint: 'alto de pagina',
                          max: 500)),
                ],
              )),
          ModalRow(
              sideTitle: 'Texto',
              child: FormSubsection(
                childList: [
                  TitledWidget(
                      'Tamaño de texto',
                      CustomNumberPicker(
                          icon: Icons.format_size,
                          initialValue: 8,
                          textController: tamanio,
                          hint: 'tamaño de texo',
                          max: 50)),
                ],
              )),
          ModalRow(
              sideTitle: 'Empresa',
              child: AsyncAutocomplete(
                id: '0',
                dataController: empresaController,
                link: 'http://190.52.165.206:3000/companies',
                label: 'Empresa',
                filtro: 'NAME',
                icon: Icons.work,
                setUpAndDown: (bool value) {},
              )),
          ModalRow(
              sideTitle: 'Comentario superior',
              child: SizedBox(
                height: 200,
                child: CustomTextField(
                    icon: Icons.note_outlined,
                    expand: true,
                    lenght: 1800,
                    textController: izquierdaController,
                    hint: 'Comentario superior'),
              )),
          ModalRow(
              sideTitle: 'Comentario inferior',
              child: SizedBox(
                height: 200,
                child: CustomTextField(
                    icon: Icons.note_outlined,
                    expand: true,
                    lenght: 1800,
                    textController: derechaController,
                    hint: 'Comentario inferior'),
              )),
        ]);
  }

  void onAccept() async {
    if (empresaController.text.isNotEmpty) {
      //API---------------------------------------------------

      if (mounted) {
        List reportes = await fetchReports();

        if (reportes.isEmpty) {
          int idVal = await fetchMaxReportId() + 1;

          var reporte = Report(
              widget.travels,
              idVal,
              dateFormaterString(widget.fecha),
              int.tryParse(empresaController.text)!,
              widget.userId,
              listEmpresas,
              ancho: int.tryParse(ancho.text)!,
              alto: int.tryParse(alto.text)!,
              texto: int.tryParse(tamanio.text)!,
              margenes: [
                double.tryParse(mTop.text)!,
                double.tryParse(mBottom.text)!,
                double.tryParse(mLeft.text)!,
                double.tryParse(mRight.text)!
              ]);
          Uint8List archivo = await reporte
              .generate([izquierdaController.text, derechaController.text]);
          await postReport(idVal, archivo);
        } else {
          reportId = mayorReporte(reportes);
          var reporte = Report(
              widget.travels,
              reportId,
              dateFormaterString(widget.fecha),
              int.tryParse(empresaController.text)!,
              widget.userId,
              listEmpresas,
              ancho: int.tryParse(ancho.text)!,
              alto: int.tryParse(alto.text)!,
              texto: int.tryParse(tamanio.text)!,
              margenes: [
                double.tryParse(mTop.text)!,
                double.tryParse(mBottom.text)!,
                double.tryParse(mLeft.text)!,
                double.tryParse(mRight.text)!
              ]);
          Uint8List archivo = await reporte
              .generate([izquierdaController.text, derechaController.text]);
          await updateReport(archivo);
        }
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }

      //verificar si se ha impreso
    } else {
      msgBox('Empresa no especificada', 'Especifique la empresa');
    }
  }

  int mayorReporte(List lista) {
    int mayor = 0;
    int aux = 0;
    for (var elem in lista) {
      aux = elem['ID'];
      if (aux > mayor) {
        mayor = aux;
      }
    }
    return aux;
  }

  Future<List> fetchReports() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://190.52.165.206:3000/reports_by_date?fecha=${widget.fecha}'));
    //send request
    http.StreamedResponse response = await request.send();
    //convert
    var data = await http.Response.fromStream(response);
    //convert received data to list
    List jsonResponse = json.decode(data.body);
    return jsonResponse;
  }

  Future<void> postReport(int id, Uint8List archivo) async {
    final String pdfBase64 = base64Encode(archivo);

    var request = http.Request(
        'POST', Uri.parse('http://190.52.165.206:3000/reports_add'));
    request.bodyFields = {
      'id': id.toString(),
      'date': widget.fecha,
      'time': horaString(DateTime.now()),
      'user': widget.userId.toString(),
      'empre': empresaController.text,
      'archivo': pdfBase64
    };

    await request.send();
  }

  Future<void> updateReport(Uint8List archivo) async {
    final String pdfBase64 = base64Encode(archivo);
    var request = http.Request(
        'POST', Uri.parse('http://190.52.165.206:3000/reports_update'));
    request.bodyFields = {
      'date': widget.fecha,
      'time': horaString(DateTime.now()),
      'user': widget.userId.toString(),
      'empre': empresaController.text,
      'archivo': pdfBase64
    };

    await request.send();
  }

  Future<int> fetchMaxReportId() async {
    var request = http.Request(
        'GET', Uri.parse('http://190.52.165.206:3000/max_reports_id'));

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

  String dateFormaterString(String inputDate) {
    List<String> numbers = inputDate.split('-');
    return '${numbers[2]}/${numbers[1]}/${numbers[0]}';
  }
}
