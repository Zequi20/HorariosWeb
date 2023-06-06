import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/pdf_est.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart';

class Report {
  Report(this.lista);
  List<Group> lista;
  void generate(BuildContext context) {
    _printPdf(context);
  }

  Future<void> _printPdf(BuildContext context) async {
    final formato = pw.PdfPageFormat.a3.copyWith(
        marginTop: 10, marginBottom: 10, marginLeft: 10, marginRight: 10);

    final pdf = await _generatePdf(formato);

    _openPdfInNewTab(pdf);
  }

  Future<Uint8List> _generatePdf(pw.PdfPageFormat format) async {
    final pdf = Document();

    final page = MultiPage(
      pageFormat: format,
      build: (context) {
        return [Titled(lista)];
      },
    );

    pdf.addPage(page);

    return pdf.save();
  }

  void _openPdfInNewTab(Uint8List pdfBytes) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement()
      ..href = url
      ..download = 'reporte.pdf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
