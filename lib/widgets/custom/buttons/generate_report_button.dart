import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/modals/generador/modal_generar_reporte.dart';

class GenerateReportButton extends StatefulWidget {
  const GenerateReportButton(
      {super.key,
      required this.userId,
      required this.futureCallback,
      required this.padding,
      required this.fecha});
  final int userId;
  final Future<List<Group>> futureCallback;
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.futureCallback,
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
                      backgroundColor:
                          MaterialStatePropertyAll(principalColor)),
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
            return Text(
              'Cargando...',
              style: TextStyle(color: blanco),
            );
          }
        });
  }
}
