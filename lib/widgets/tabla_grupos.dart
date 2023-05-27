import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_group.dart';

class GroupTable extends StatefulWidget {
  const GroupTable({super.key, required this.travels, required this.index});
  final List<Group> travels;
  final int index;
  @override
  State<GroupTable> createState() => _GroupTableState();
}

class _GroupTableState extends State<GroupTable> {
  ScrollController horizontalScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      controller: horizontalScroll,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontalScroll,
        child: DataTable(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            columns: const [
              DataColumn(label: Text('PARTIDA')),
              DataColumn(label: Text('LLEGADA')),
              DataColumn(label: Text('VEHICULO')),
              DataColumn(label: Text('CONDUCTOR')),
              DataColumn(label: Text('GUARDA')),
              DataColumn(label: Text('NOTA')),
              DataColumn(label: Text('KM')),
            ],
            rows: widget.travels[widget.index].data.isNotEmpty
                ? widget.travels[widget.index].data
                : []),
      ),
    );
  }
}
