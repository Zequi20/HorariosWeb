import 'package:flutter/material.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker(
      {super.key, required this.fechaControlador, required this.title});
  final TextEditingController fechaControlador;
  final String title;
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  GlobalKey textKey = GlobalKey();
  DateTime dateValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextField(
      mouseCursor: MaterialStateMouseCursor.clickable,
      decoration: InputDecoration(
          hintText: widget.title,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
      key: textKey,
      controller: widget.fechaControlador,
      readOnly: true,
      onTap: () async {
        final pickedDate = await showWebDatePicker(
          width: 300,
          context: textKey.currentContext!,
          initialDate: dateValue,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 14000)),
        );
        if (pickedDate != null) {
          widget.fechaControlador.text =
              DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
    );
  }
}
