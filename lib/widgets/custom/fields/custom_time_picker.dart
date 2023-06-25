import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker(
      {super.key, required this.timeController, required this.title});
  final TextEditingController timeController;
  final String title;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: () async {
        widget.timeController.text = await showTimePicker(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: TimePickerDialog(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                hourLabelText: 'Hora',
                minuteLabelText: 'Minuto',
                helpText: 'Ingresar hora (${widget.title})',
                confirmText: 'Confirmar',
                cancelText: 'Cancelar',
                errorInvalidText: 'Formato invalido',
                initialTime: TimeOfDay.now(),
              ),
            );
          },
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          if (value != null) {
            return '${MaterialLocalizations.of(context).formatTimeOfDay(value, alwaysUse24HourFormat: true)}:00';
          } else {
            return widget.timeController.text;
          }
        });
      },
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: widget.title,
          filled: true,
          fillColor: Colors.white),
      readOnly: true,
      controller: widget.timeController,
    );
  }
}
