import 'package:horarios_web/models/model_group.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';

class Estructura extends StatelessWidget {
  Estructura(this.list);
  final List list;
  @override
  Widget build(Context context) {
    var blackColor = const PdfColor(0, 0, 0);
    return Table(
      columnWidths: {
        0: const FractionColumnWidth(0.25),
        1: const FractionColumnWidth(0.28),
        2: const FractionColumnWidth(0.3),
        3: const FractionColumnWidth(0.8),
        4: const FractionColumnWidth(1),
        5: const FractionColumnWidth(1)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.full,
      border: TableBorder(
          horizontalInside: BorderSide(color: blackColor),
          verticalInside: BorderSide(color: blackColor)),
      children: list
          .map((e) => TableRow(children: [
                TableCell(Text(
                  e['DEPARTURE_TIME']
                      .toString()
                      .split('.')[0]
                      .replaceRange(5, 5, '.')
                      .split('.')[0],
                  textAlign: TextAlign.center,
                )),
                TableCell(Text(
                  e['ARRIVAL_TIME']
                      .toString()
                      .split('.')[0]
                      .replaceRange(5, 5, '.')
                      .split('.')[0],
                  textAlign: TextAlign.center,
                )),
                TableCell(Text(
                  e['VEHICLE'],
                  textAlign: TextAlign.center,
                )),
                TableCell(Text(
                  e['DRIVER1'],
                  textAlign: TextAlign.center,
                )),
                TableCell(Text(
                  e['DRIVER2'],
                  textAlign: TextAlign.center,
                )),
                TableCell(Text(
                  e['NOTE'],
                  textAlign: TextAlign.center,
                ))
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
          Padding(padding: const EdgeInsets.all(5), child: child)
        ]));
  }
}

class Titled extends StatelessWidget {
  Titled(this.list);
  final List<Group> list;
  var blackColor = const PdfColor(0, 0, 0);
  @override
  Widget build(Context context) {
    List<Widget> contenido = list
        .map((e) => Table(
                defaultColumnWidth: const FractionColumnWidth(1),
                border: TableBorder.symmetric(
                    outside: BorderSide(color: blackColor)),
                children: [
                  TableRow(children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: blackColor)),
                        child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(e.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))))
                  ]),
                  TableRow(children: [Estructura(e.travelsData)])
                ]))
        .toList();
    contenido.add(Table(children: [
      TableRow(children: [Padding(padding: const EdgeInsets.all(8.0))])
    ]));
    contenido.insert(
        0,
        Table(border: TableBorder.all(color: blackColor), children: [
          TableRow(children: [
            Padding(
                padding: const EdgeInsets.all(2),
                child: Text('EMPRESA GUAIREÑA DE TRANSPORTE Y TURISMO S.R.L',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
          TableRow(
              decoration: const BoxDecoration(color: PdfColors.orange),
              children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('HORARIO DE VIAJE: 5 DE JUNIO DE 2023',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center))
              ])
        ]));
    contenido.insert(
        1,
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.full,
            columnWidths: {
              0: const FractionColumnWidth(0.25),
              1: const FractionColumnWidth(0.28),
              2: const FractionColumnWidth(0.3),
              3: const FractionColumnWidth(0.8),
              4: const FractionColumnWidth(1),
              5: const FractionColumnWidth(1)
            },
            border: TableBorder.all(color: blackColor),
            children: [
              TableRow(children: [
                TableCell(Text('Salida')),
                TableCell(Text('Llegada')),
                TableCell(Text('Coche')),
                TableCell(Text('Conductor')),
                TableCell(Text('Guarda')),
                TableCell(Text('Nota'))
              ]),
            ]));
    contenido.add(Table(children: [
      TableRow(children: [
        Container(
            height: 1000,
            width: double.maxFinite,
            decoration: BoxDecoration(border: Border.all(color: blackColor)))
      ])
    ]));
    return Container(
        decoration:
            const BoxDecoration(boxShadow: [BoxShadow(offset: PdfPoint(2, 2))]),
        child: Column(children: contenido));
  }
}
