import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/tables/tabla_grupos.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile(
      {super.key, required this.element, required this.tabla});
  final Group element;
  final GroupTable tabla;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  //Colores
  var colorBlanco = Colors.white;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: principalColor)),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: colorBlanco,
        collapsedIconColor: colorBlanco,
        collapsedTextColor: colorBlanco,
        collapsedBackgroundColor: gradPrincipalColor,
        textColor: colorBlanco,
        backgroundColor: gradPrincipalColor,
        title: Text(
          widget.element.name,
          textAlign: TextAlign.center,
        ),
        leading: Text('grupo ${widget.element.id}'),
        children: [
          widget.tabla,
        ],
      ),
    );
  }
}
