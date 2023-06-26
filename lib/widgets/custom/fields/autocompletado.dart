import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_generic_object.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsyncAutocomplete extends StatefulWidget {
  const AsyncAutocomplete(
      {super.key,
      required this.dataController,
      required this.link,
      required this.label,
      required this.filtro});

  final TextEditingController dataController;
  final String link;
  final String filtro;
  final String label;
  @override
  State<AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState<T> extends State<AsyncAutocomplete> {
  TextEditingController control = TextEditingController();
  List<GenericObject> options = [];
  Color bordeColor = Colors.white70;
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
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (control) {
        if (control.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options
            .map((e) => e.nombre)
            .where((option) =>
                option.toLowerCase().contains(control.text.toLowerCase()))
            .cast();
      },
      onSelected: (String selectedOption) {
        control.text = selectedOption;
        widget.dataController.text = options
            .where((option) => option.nombre == selectedOption)
            .first
            .id
            .toString();
        setState(() {});
      },
      fieldViewBuilder: (BuildContext context, control, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          focusNode: focusNode,
          onFieldSubmitted: (String? value) {
            FocusScope.of(context).requestFocus(focusNode);
            onFieldSubmitted();
          },
          controller: control,
          onChanged: (value) {
            if (value.isEmpty) {
              bordeColor = Colors.white70;
            } else {
              bordeColor = Colors.white;
            }
            setState(() {});
          },
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 7)),
            border: const OutlineInputBorder(borderSide: BorderSide()),
            filled: true,
            fillColor: bordeColor,
            hintText: widget.label,
          ),
        );
      },
    );
  }
}
