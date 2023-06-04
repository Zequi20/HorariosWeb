import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';

class Report extends StatelessWidget {
  const Report({super.key, required this.lista});
  final List<Group> lista;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentTextStyle: const TextStyle(color: Colors.black),
      content: Column(
        children: [
          Table(
            border: TableBorder.all(color: Colors.black),
            children: const [
              TableRow(children: [
                Text(
                  'Soy un titulo',
                  textAlign: TextAlign.center,
                )
              ]),
              TableRow(children: [Estructura()])
            ],
          ),
          Table(
            border: TableBorder.all(color: Colors.black),
            children: const [
              TableRow(children: [
                Text(
                  'Soy un titulo',
                  textAlign: TextAlign.center,
                )
              ]),
              TableRow(children: [Estructura()])
            ],
          ),
          Table(
            border: TableBorder.all(color: Colors.black),
            children: const [
              TableRow(children: [
                Text(
                  'Soy un titulo',
                  textAlign: TextAlign.center,
                )
              ]),
              TableRow(children: [Estructura()])
            ],
          ),
          Table(
            border: TableBorder.all(color: Colors.black),
            children: const [
              TableRow(children: [
                Text(
                  'Soy un titulo',
                  textAlign: TextAlign.center,
                )
              ]),
              TableRow(children: [Estructura()])
            ],
          )
        ],
      ),
    );
  }
}

class Estructura extends StatelessWidget {
  const Estructura({super.key});

  @override
  Widget build(BuildContext context) {
    List<List<String>> tembo = [
      ['Caca', 'Pedo', 'Culo'],
      ['KUKA', 'EXPLAOTE', 'LA CHUhjghhghNN']
    ];
    return Table(
      border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.black),
          verticalInside: BorderSide(color: Colors.black)),
      children: tembo
          .map((e) => TableRow(children: [
                TableCell(
                    child: Text(
                  e[0],
                  textAlign: TextAlign.center,
                )),
                TableCell(child: Text(e[1], textAlign: TextAlign.center)),
                TableCell(child: Text(e[2], textAlign: TextAlign.center))
              ]))
          .toList(),
    );
  }
}
