import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.textController,
      required this.hint,
      this.lenght = 50});
  final TextEditingController textController;
  final String hint;
  final int lenght;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

Color fillColor = Colors.white70;

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: FocusNode(),
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
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 7)),
          hintText: widget.hint,
          filled: true,
          fillColor: fillColor),
    );
  }
}
