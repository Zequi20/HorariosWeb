import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/pdf_est.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Report {
  Report(this.lista, this.reportId, this.fecha);
  final int reportId;
  final String fecha;
  List<Group> lista;
  void generate(BuildContext context, List<String> coments) {
    _printPdf(context, coments);
  }

  Future<void> _printPdf(BuildContext context, List<String> coments) async {
    final formato = PdfPageFormat.a3.copyWith(
        marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10);

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
                        'EMPRESA GUAIREÑA DE TRANSPORTE Y TURISMO S.R.L',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
              ]),
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.orange),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                            'HORARIO DE VIAJES DE LA FECHA $fecha \t NRO $reportId ',
                            textAlign: pw.TextAlign.center,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)))
                  ])
            ]);
      },
      footer: (context) => pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black),
        children: [
          pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(coments[0])),
            pw.Container(
                padding: const pw.EdgeInsets.all(5), child: pw.Text(coments[1]))
          ])
        ],
      ),
      pageFormat: format,
      build: (context) {
        return [Titled(lista)];
      },
    );

    pdf.addPage(page);
    await Printing.layoutPdf(
        name: 'Reporte.pdf', onLayout: (format) => pdf.save());
  }
}
