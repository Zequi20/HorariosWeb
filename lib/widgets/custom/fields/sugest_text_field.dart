import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:horarios_web/widgets/custom/containers/focusable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SugestTextField extends StatefulWidget {
  const SugestTextField({super.key, required this.notaController});
  final TextEditingController notaController;
  @override
  State<SugestTextField> createState() => _SugestTextFieldState();
}

class _SugestTextFieldState extends State<SugestTextField> {
  FocusNode foco = FocusNode();
  List<String> sugestions = [];
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);

  Color fillColor = Colors.white70;
  //double opacidad = 0.5;
  Future getSugestData(String searched) async {
    List<String> options = [];

    final response = await http
        .get(Uri.parse('http://190.52.165.206:3000/notes?busqueda=$searched'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      for (var element in data) {
        options.add(element['NOTE']);
      }
    }
    sugestions =
        options.where((element) => element.startsWith(searched)).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget.notaController.addListener(() {
      getSugestData(widget.notaController.text);
    });
    foco.addListener(() {
      setState(() {});
    });
  }

  void selectSuggestion(String sugest) {
    widget.notaController.text = sugest;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: foco,
      skipTraversal: true,
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          // Cuando se presiona Enter, selecciona la primera sugerencia si está disponible.
          if (sugestions.isNotEmpty) {
            selectSuggestion(sugestions.first);
            widget.notaController.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.notaController.text.length));
          }
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          CustomField(
            lenght: null,
            textController: widget.notaController,
            hint: '',
          ),
          Opacity(
            opacity: foco.hasFocus ? 0.5 : 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 3),
              child: getSugestText(),
            ),
          )
        ],
      ),
    );
  }

  Widget getSugestText() {
    if (sugestions.isNotEmpty && widget.notaController.text != '') {
      return Text(
        sugestions.first,
        style: const TextStyle(fontSize: 16),
      );
    } else {
      sugestions.clear();
      return const Text(
        '',
        style: TextStyle(fontSize: 16),
      );
    }
  }
}

class CustomField extends StatefulWidget {
  const CustomField({
    super.key,
    required this.textController,
    required this.hint,
    this.lenght = 50,
    this.icon = Icons.abc,
  });
  final TextEditingController textController;
  final String hint;
  final int? lenght;

  final IconData icon;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  final FocusNode _foco = FocusNode();
  Color fillColor = Colors.white70;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      focusNode: _foco,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_foco);
      },
      onChanged: (value) {
        if (value.isEmpty) {
          fillColor = Colors.white70;
        } else {
          fillColor = Colors.white;
        }
        setState(() {});
      },
      controller: widget.textController,
      maxLength: widget.lenght,
      decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          prefixIconColor: gradPrincipalColor,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 7)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: widget.hint,
          filled: true,
          fillColor: fillColor),
    );
  }
}
