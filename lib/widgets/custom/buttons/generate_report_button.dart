import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/modals/generador/modal_generar_reporte.dart';

class GenerateReportButton extends StatefulWidget {
  const GenerateReportButton(
      {super.key,
      required this.userId,
      required this.padding,
      required this.fecha,
      required this.dateController});
  final int userId;
  final TextEditingController dateController;
  final double padding;
  final String fecha;
  @override
  State<GenerateReportButton> createState() => _GenerateReportButtonState();
}

class _GenerateReportButtonState extends State<GenerateReportButton> {
  List<Group> travels = [];
  var blanco = Colors.white;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTravelsByGroup(widget.dateController.text),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          travels = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding),
            child: TextButton.icon(
                style: ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                      color: blanco,
                    )),
                    backgroundColor: MaterialStatePropertyAll(principalColor)),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModalGeneradorReporte(
                          fecha: widget.fecha,
                          userId: widget.userId,
                          travels: travels,
                        );
                      });
                },
                icon: Icon(
                  Icons.note_add,
                  color: blanco,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Generar Documento',
                    style: TextStyle(color: blanco),
                    textAlign: TextAlign.center,
                  ),
                )),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
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
    }
    return travels;
  }

  String dateFormaterString(String inputDate) {
    List<String> numbers = inputDate.split('/');
    return '${numbers[2]}-${numbers[1]}-${numbers[0]}';
  }
}
