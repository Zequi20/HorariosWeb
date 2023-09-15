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
    final formato = xd.PdfPageFormat(
            ancho * xd.PdfPageFormat.cm, alto * xd.PdfPageFormat.cm)
        .copyWith(
            marginTop: margenes[0],
            marginBottom: margenes[1],
            marginLeft: margenes[2],
            marginRight: margenes[3]);

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
                        pw.Expanded(
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
                        pw.Expanded(child: pw.Text(' ')),
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
                    width: 0.5),
                children: [
                  pw.TableRow(children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(coments[0],
                                  style: pw.TextStyle(
                                      fontSize: texto.toDouble()))),
                          pw.Divider(
                              color:
                                  coments[0].isNotEmpty || coments[1].isNotEmpty
                                      ? xd.PdfColors.black
                                      : xd.PdfColors.white,
                              height: 0.5),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(coments[1],
                                style:
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
}
