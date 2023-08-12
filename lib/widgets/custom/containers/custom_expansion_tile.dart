/* import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/tables/tabla_grupos.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    required this.element,
    required this.tabla,
  });
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
  Color borde = const Color.fromARGB(255, 99, 1, 1);
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (value) {
          borde = resaltadoColor;
          setState(() {});
        } else {
          borde = principalColor;
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(width: 4, color: borde)),
          child: ExcludeFocus(
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              initiallyExpanded: true,
              textColor: colorBlanco,
              iconColor: colorBlanco,
              backgroundColor: gradPrincipalColor,
              collapsedIconColor: colorBlanco,
              collapsedTextColor: colorBlanco,
              collapsedBackgroundColor: gradPrincipalColor,
              title: Text(
                widget.element.name,
                textAlign: TextAlign.center,
              ),
              leading: Text('GRUPO ${widget.element.id}'),
              children: [
                widget.tabla,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */