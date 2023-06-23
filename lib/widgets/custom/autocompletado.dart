import 'package:flutter/material.dart';

class Autocompletado extends StatefulWidget {
  const Autocompletado({super.key});

  @override
  State<Autocompletado> createState() => _AutocompletadoState();
}

class _AutocompletadoState extends State<Autocompletado> {
  TextEditingController control = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List options = ['banana', 'pera', 'durazno'];
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (control) {
        if (control.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options
            .where((option) => option.contains(control.text.toLowerCase()))
            .cast();
      },
      onSelected: (String selectedOption) {
        control.text = selectedOption;
        setState(() {});
      },
    );
  }
}

/*
Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selectedOption) {
        setState(() {
          _selectedOption = selectedOption;
          _textEditingController.text = selectedOption;
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: _textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Buscar',
          ),
          onChanged: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = _options[index];
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

*/