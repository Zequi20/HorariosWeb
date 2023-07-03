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
  Color fillColor = Colors.white70;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  FocusNode foco = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        tapEvent();
      },
      focusNode: foco,
      mouseCursor: MaterialStateMouseCursor.clickable,
      onTap: tapEvent,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.access_time),
          prefixIconColor: gradPrincipalColor,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 7)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: widget.title,
          filled: true,
          fillColor: fillColor),
      readOnly: true,
      controller: widget.timeController,
    );
  }

  void tapEvent() async {
    widget.timeController.text = await showTimePicker(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                      accentColor: resaltadoColor,
                      primarySwatch: MaterialColor(principalColor.value, {
                        50: principalColor,
                        100: principalColor,
                        200: principalColor,
                        300: principalColor,
                        400: principalColor,
                        500: principalColor,
                        600: principalColor,
                        700: principalColor,
                        800: principalColor,
                        900: principalColor,
                      }))),
              child: TimePickerDialog(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                hourLabelText: 'Hora',
                minuteLabelText: 'Minuto',
                helpText: 'Ingresar hora (${widget.title})',
                confirmText: 'Confirmar',
                cancelText: 'Cancelar',
                errorInvalidText: 'Formato invalido',
                initialTime: TimeOfDay.now(),
              )),
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        fillColor = Colors.white;
        setState(() {});
        FocusScope.of(context).requestFocus(foco);
        return MaterialLocalizations.of(context)
            .formatTimeOfDay(value, alwaysUse24HourFormat: true);
      } else {
        FocusScope.of(context).requestFocus(foco);
        return widget.timeController.text;
      }
    });
  }
}
