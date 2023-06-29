import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key, required this.fechaControlador, required this.title});
  final TextEditingController fechaControlador;
  final String title;
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  GlobalKey textKey = GlobalKey();
  DateTime dateValue = DateTime.now();
  var fillColor = Colors.white70;
  var _selectedDate = DateTime.now();
  var foco = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (value) {
        foco.requestFocus();
        tapEvent();
      },
      focusNode: foco,
      mouseCursor: MaterialStateMouseCursor.clickable,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 7)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: widget.title,
          filled: true,
          fillColor: fillColor),
      key: textKey,
      controller: widget.fechaControlador,
      readOnly: true,
      onTap: tapEvent,
    );
  }

  void tapEvent() async {
    final DateTime? pickedDate = await showDatePicker(
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: _selectedDate,
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
              colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: principalColor,
                  onPrimary: Colors.white,
                  secondary: Colors.brown,
                  onSecondary: Colors.brown,
                  error: Colors.orange,
                  onError: Colors.orange,
                  background: Colors.white,
                  onBackground: Colors.white,
                  surface: Colors.black,
                  onSurface: Colors.black)),
          child: DatePickerDialog(
            initialEntryMode: DatePickerEntryMode.input,
            initialDate: _selectedDate,
            lastDate: DateTime(2100),
            firstDate: DateTime(1900),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.fechaControlador.text =
            "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year.toString()}";
      });
    }
  }
}
