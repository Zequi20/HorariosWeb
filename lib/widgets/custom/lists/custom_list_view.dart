import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';
import 'package:horarios_web/widgets/custom/containers/custom_expansion_tile.dart';
import 'package:horarios_web/widgets/custom/tables/tabla_grupos.dart';

class CustomListView extends StatefulWidget {
  const CustomListView(
      {super.key, required this.list, required this.updateParent});
  final List<Group> list;
  final VoidCallback updateParent;

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  //colors
  var colorBlanco = Colors.white;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 3,
              color: colorBlanco,
            ),
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return CustomExpansionTile(
              element: widget.list[index],
              tabla: GroupTable(
                  travels: widget.list,
                  index: index,
                  updateParent: widget.updateParent));
        });
  }
}
