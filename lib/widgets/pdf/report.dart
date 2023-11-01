import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/pdf/pdf_est.dart';
import 'package:pdf/pdf.dart' as xd;
import 'package:pdf/widgets.dart' as pw;

class Report {
  Report(this.lista, this.reportId, this.fecha, this.empresaId, this.userId,
      this.empresas,
      {this.ancho = 21,
      this.alto = 33,
      this.margenes = const [2, 2, 2, 2],
      this.texto = 6});
  final int reportId;
  final String fecha;
  final int empresaId;
  final int userId;
  final List<Empresa> empresas;
  List<Group> lista;
  final int ancho;
  final int alto;
  final List<double> margenes;
  final int texto;
  Future generate(List<String> coments) async {
    return await _printPdf(coments);
  }

  Future _printPdf(List<String> coments) async {
    double pageWidthInMm =
        ancho.toDouble(); // Ancho en mm (por ejemplo, tamaño A4)
    double pageHeightInMm =
        alto.toDouble(); // Alto en mm (por ejemplo, tamaño A4)

    // Convierte milímetros a puntos (1 mm = 2.83464567 puntos)
    double pageWidthInPoints = pageWidthInMm * 2.83464567;
    double pageHeightInPoints = pageHeightInMm * 2.83464567;

    final formato = xd.PdfPageFormat.letter.copyWith(
        marginTop: margenes[0],
        marginBottom: margenes[1],
        marginLeft: margenes[2],
        marginRight: margenes[3],
        width: pageWidthInPoints,
        height: pageHeightInPoints);

    return await _generatePdf(formato, coments);
  }

  Future _generatePdf(xd.PdfPageFormat format, List<String> coments) async {
    final pdf = pw.Document();

    final page = pw.MultiPage(
      header: (context) {
        return pw.Table(
            border: pw.TableBorder.all(color: xd.PdfColors.black, width: 0.5),
            children: [
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Table(children: [
                      pw.TableRow(children: [
                        pw.Container(
                            child: pw.Text('ID $reportId',
                                textAlign: pw.TextAlign.left,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: texto.toDouble()))),
                        pw.Expanded(
                            child: pw.Text(
                                empresas
                                    .where((element) => element.id == empresaId)
                                    .first
                                    .nombre
                                    .toUpperCase(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: texto.toDouble()))),
                        pw.Container(child: pw.Text(' ')),
                      ])
                    ]))
              ]),
              pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: xd.PdfColors.orange),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('HORARIO DE VIAJES DE LA FECHA $fecha',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: texto.toDouble())))
                  ])
            ]);
      },
      pageFormat: format,
      build: (context) {
        return [
          Titled(
              lista,
              texto,
              pw.Table(
                border: pw.TableBorder.all(
                    color: coments[0].isNotEmpty || coments[1].isNotEmpty
                        ? xd.PdfColors.black
                        : xd.PdfColors.white,
                    width: 1),
                children: [
                  pw.TableRow(children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: getRichFromText(coments[0],
                                  pw.TextStyle(fontSize: texto.toDouble()))),
                          pw.Divider(
                              color:
                                  coments[0].isNotEmpty || coments[1].isNotEmpty
                                      ? xd.PdfColors.black
                                      : xd.PdfColors.white,
                              height: 0.5),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: getRichFromText(coments[1],
                                pw.TextStyle(fontSize: texto.toDouble())),
                          )
                        ])
                  ])
                ],
              ))
        ];
      },
    );

    pdf.addPage(page);
    Uint8List documento = await pdf.save();
    final blob = html.Blob([documento], 'application/pdf');

    // Crea un objeto URL para el Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crea un objeto de ventana emergente
    html.window.open(url, '_blank');

    return documento;
  }

  pw.RichText getRichFromText(String text, pw.TextStyle style) {
    final RegExp boldRegExp = RegExp(r'\*(.*?)\*');
    List<pw.InlineSpan> children = [];
    int currentIndex = 0;

    for (var match in boldRegExp.allMatches(text)) {
      final boldText = match.group(1);
      final startIndex = match.start;
      final endIndex = match.end;

      if (boldText != null) {
        if (startIndex > currentIndex) {
          // Agregar el texto antes de la expresión en negrita
          children.add(pw.TextSpan(
            text: text.substring(currentIndex, startIndex),
          ));
        }

        // Agregar el texto en negrita
        children.add(pw.TextSpan(
          text: boldText,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ));

        currentIndex = endIndex;
      }
    }

    if (currentIndex < text.length) {
      // Agregar cualquier texto restante
      children.add(pw.TextSpan(
        text: text.substring(currentIndex),
      ));
    }

    return pw.RichText(
      text: pw.TextSpan(
        style: style,
        children: children,
      ),
    );
  }
}
