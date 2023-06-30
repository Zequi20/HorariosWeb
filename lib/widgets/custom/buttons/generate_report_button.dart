import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/modals/generador/modal_generar_reporte.dart';

class GenerateReportButton extends StatefulWidget {
  const GenerateReportButton(
      {super.key, required this.userId, required this.futureCallback});
  final int userId;
  final Future<Object?> futureCallback;

  @override
  State<GenerateReportButton> createState() => _GenerateReportButtonState();
}

class _GenerateReportButtonState extends State<GenerateReportButton> {
  var blanco = Colors.white;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.futureCallback,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TextButton.icon(
                style: ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                      color: blanco,
                    )),
                    backgroundColor: MaterialStatePropertyAll(principalColor)),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModalGeneradorReporte(userId: widget.userId);
                      });
                },
                icon: Icon(
                  Icons.note_add,
                  color: blanco,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Generar reporte',
                    style: TextStyle(color: blanco),
                  ),
                ));
          } else {
            return Text(
              'Cargando...',
              style: TextStyle(color: blanco),
            );
          }
        });
  }
}
