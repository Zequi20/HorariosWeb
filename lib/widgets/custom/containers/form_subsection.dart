import 'package:flutter/material.dart';

class FormSubsection extends StatefulWidget {
  const FormSubsection({super.key, required this.childList});
  final List<TitledWidget> childList;
  @override
  State<FormSubsection> createState() => _FormSubsectionState();
}

class _FormSubsectionState extends State<FormSubsection> {
  //colores
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        TableRow(
            children: widget.childList
                .map((e) => TableCell(
                        child: Text(
                      e.title,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    )))
                .toList()),
        TableRow(children: widget.childList.map((e) => e.childWidget).toList())
      ],
    );
  }
}

class TitledWidget {
  final String title;
  final Widget childWidget;

  TitledWidget(this.title, this.childWidget);
}
