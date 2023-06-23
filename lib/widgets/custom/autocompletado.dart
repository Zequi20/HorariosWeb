import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_generic_object.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsyncAutocomplete extends StatefulWidget {
  const AsyncAutocomplete(
      {super.key,
      required this.dataController,
      required this.link,
      required this.label});

  final TextEditingController dataController;
  final String link;
  final String label;
  @override
  State<AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState<T> extends State<AsyncAutocomplete> {
  TextEditingController control = TextEditingController();
  List<GenericObject> options = [];
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
        options.add(GenericObject(element['ID'], element['NAME']));
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
        print('id ${widget.dataController.text}');
        setState(() {});
      },
      fieldViewBuilder: (BuildContext context, control, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          controller: control,
          focusNode: focusNode,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
