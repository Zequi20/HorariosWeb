import 'package:horarios_web/models/model_group.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class Estructura extends StatelessWidget {
  Estructura(this.list, this.textoSize);
  final List list;
  final int textoSize;
  @override
  Widget build(Context context) {
    var blackColor = const PdfColor(0, 0, 0);
    return Table(
      columnWidths: {
        0: const FractionColumnWidth(0.30),
        1: const FractionColumnWidth(0.30),
        2: const FractionColumnWidth(1),
        3: const FractionColumnWidth(1),
        4: const FractionColumnWidth(0.30),
        5: const FractionColumnWidth(1)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.full,
      border: TableBorder(
          //horizontalInside: BorderSide(color: blackColor, width: 0.5),
          verticalInside: list.isNotEmpty
              ? BorderSide(color: blackColor, width: 0.5)
              : BorderSide.none),
      children: list
          .map((e) => TableRow(
                  decoration: BoxDecoration(
                      border: Border(
                          top: list.indexOf(e) != 0
                              ? BorderSide(color: blackColor, width: 0.5)
                              : BorderSide.none)),
                  children: [
                    TableCell(Text(
                        e['DEPARTURE_TIME']
                            .toString()
                            .split('.')[0]
                            .replaceRange(5, 5, '.')
                            .split('.')[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text(e['VEHICLE'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text(e['DRIVER1'],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text(e['DRIVER2'],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text(
                        e['ARRIVAL_TIME']
                            .toString()
                            .split('.')[0]
                            .replaceRange(5, 5, '.')
                            .split('.')[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text(e['NOTE'],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: textoSize.toDouble())))
                  ]))
          .toList(),
    );
  }
}

class TableCell extends StatelessWidget {
  final Widget child;

  TableCell(this.child);
  var blackColor = const PdfColor(0, 0, 0);

  @override
  Widget build(Context context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(padding: const EdgeInsets.all(2), child: child)
        ]));
  }
}

class Titled extends StatelessWidget {
  Titled(this.list, this.textoSize, this.footerWidget);
  final int textoSize;
  final List<Group> list;
  final Widget footerWidget;
  var blackColor = const PdfColor(0, 0, 0);
  @override
  Widget build(Context context) {
    List<Widget> contenido = list
        .where((element) => element.travelsData.isNotEmpty)
        .map((e) => Table(
                defaultColumnWidth: const FractionColumnWidth(1),
                border: TableBorder(
                    horizontalInside: BorderSide(color: blackColor, width: 0.5),
                    bottom: BorderSide(color: blackColor, width: 0.5),
                    right: BorderSide(color: blackColor, width: 0.5),
                    left: BorderSide(color: blackColor, width: 0.5)),
                //outside: BorderSide(color: blackColor, width: 0.5)),
                children: [
                  TableRow(children: [
                    Container(
                        /*  decoration: BoxDecoration(
                            border: Border.all(color: blackColor, width: 0.5)), */
                        child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(e.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textoSize.toDouble()))))
                  ]),
                  TableRow(children: [Estructura(e.travelsData, textoSize)])
                ]))
        .toList();

    contenido.insert(
        0,
        Table(
            border: TableBorder.all(color: blackColor, width: 0.5),
            defaultVerticalAlignment: TableCellVerticalAlignment.full,
            columnWidths: {
              0: const FractionColumnWidth(0.30),
              1: const FractionColumnWidth(0.30),
              2: const FractionColumnWidth(1),
              3: const FractionColumnWidth(1),
              4: const FractionColumnWidth(0.30),
              5: const FractionColumnWidth(1)
            },
            // border: TableBorder.all(color: blackColor, width: 0.5),
            children: [
              TableRow(
                  decoration: const BoxDecoration(color: PdfColors.orange100),
                  children: [
                    TableCell(Text('Salida',
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text('Coche',
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text('Conductor',
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(Text('Guarda',
                        style: TextStyle(fontSize: textoSize.toDouble()))),
                    TableCell(FittedBox(
                        child: Text('Retorno',
                            style: TextStyle(fontSize: textoSize.toDouble())))),
                    TableCell(Text('Nota',
                        style: TextStyle(fontSize: textoSize.toDouble())))
                  ]),
            ]));
    contenido.add(footerWidget);
    return Column(children: contenido);
  }
}
