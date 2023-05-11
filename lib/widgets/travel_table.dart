import 'package:flutter/material.dart';

class TravelTable extends StatefulWidget {
  const TravelTable({super.key, this.rows = const []});
  final List<DataRow>? rows;
  @override
  State<TravelTable> createState() => _TravelTableState();
}

class _TravelTableState extends State<TravelTable> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('HORA IDA')),
          DataColumn(label: Text('COCHE')),
          DataColumn(label: Text('CONDUCTOR')),
          DataColumn(label: Text('GUARDA')),
          DataColumn(label: Text('HORA VUELTA')),
          DataColumn(label: Text('NOTA')),
          DataColumn(label: Text('KM'))
        ],
        rows: widget.rows!,
      ),
    );
  }
}
