import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_generic_object.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiDropDrown extends StatefulWidget {
  const ApiDropDrown(
      {super.key,
      required this.dataController,
      required this.link,
      required this.label,
      required this.filtro,
      required this.icon});

  final TextEditingController dataController;
  final String link;
  final String filtro;
  final String label;
  final IconData icon;
  @override
  State<ApiDropDrown> createState() => _ApiDropDrownState();
}

class _ApiDropDrownState<T> extends State<ApiDropDrown> {
  TextEditingController control = TextEditingController();
  List<GenericObject> options = [];
  Color fondoColor = Colors.white70;
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  FocusNode foco = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchData(widget.link);
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  Future fetchData(String link) async {
    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      for (var element in data) {
        options.add(
            GenericObject(element['ID'], element[widget.filtro].toString()));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        isExpanded: true,
        value: widget.dataController.text,
        decoration: InputDecoration(
            prefixIcon: Icon(widget.icon),
            prefixIconColor: gradPrincipalColor,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 7)),
            hintText: widget.label,
            filled: true,
            fillColor: fondoColor),
        items: options
            .map((e) => DropdownMenuItem(
                  value: e.id.toString(),
                  child: Text(
                    e.nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: (id) {
          widget.dataController.text = id.toString();
          setState(() {});
        });
  }
}
