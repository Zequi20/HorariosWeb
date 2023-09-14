import 'package:flutter/foundation.dart';
import 'package:hex/hex.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowPdfButton extends StatelessWidget {
  const ShowPdfButton({super.key, required this.id});
  final String id;
  final principalColor = const Color.fromARGB(255, 99, 1, 1);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: getPdf,
      icon: Icon(
        Icons.remove_red_eye_outlined,
        color: principalColor,
      ),
      label: Text(
        'Mostrar',
        style: TextStyle(color: principalColor),
      ),
    );
  }

  Future<void> getPdf() async {
    final response = await http.get(
      Uri.parse('http://190.52.165.206:3000/descargar-pdf/$id'),
    );

    if (response.statusCode == 200) {
      final data = response.body;

      final blob = html.Blob([HEX.decode(data)], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    } else {
      // Manejar errores de solicitud aquí si es necesario
      if (kDebugMode) {
        print('Error al obtener el PDF: ${response.statusCode}');
      }
    }
  }
}
