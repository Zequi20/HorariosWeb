import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_empresa.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/pdf/pdf_est.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  void generate(BuildContext context, List<String> coments) {
    _printPdf(context, coments);
  }

  Future<void> _printPdf(BuildContext context, List<String> coments) async {
    final formato =
        PdfPageFormat(ancho * PdfPageFormat.cm, alto * PdfPageFormat.cm)
            .copyWith(
                marginTop: margenes[0],
                marginBottom: margenes[1],
                marginLeft: margenes[2],
                marginRight: margenes[3]);

    await _generatePdf(formato, coments);
  }

  Future _generatePdf(PdfPageFormat format, List<String> coments) async {
    final pdf = pw.Document();

    final page = pw.MultiPage(
      header: (context) {
        return pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            children: [
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                        empresas
                            .where((element) => element.id == empresaId)
                            .first
                            .nombre
                            .toUpperCase(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: texto.toDouble())))
              ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.orange),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                            'HORARIO DE VIAJES DE LA FECHA $fecha \t NRO $reportId ',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: texto.toDouble())))
                  ])
            ]);
      },
      footer: (context) => pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black),
        children: [
          pw.TableRow(children: [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(coments[0],
                          style: pw.TextStyle(fontSize: texto.toDouble()))),
                  pw.Divider(color: PdfColors.black, height: 1),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(coments[1],
                        style: pw.TextStyle(fontSize: texto.toDouble())),
                  )
                ])
          ])
        ],
      ),
      pageFormat: format,
      build: (context) {
        return [Titled(lista, texto)];
      },
    );

    pdf.addPage(page);
    await Printing.layoutPdf(
        name: 'Reporte.pdf', onLayout: (format) => pdf.save());
  }
}
