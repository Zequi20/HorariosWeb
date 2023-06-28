import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.textController,
      required this.hint,
      this.lenght = 50,
      this.numeric = false});
  final TextEditingController textController;
  final String hint;
  final int lenght;
  final bool numeric;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode foco = FocusNode();
  Color fillColor = Colors.white70;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.numeric
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ]
          : [],
      focusNode: foco,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(foco);
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
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 7)),
          hintText: widget.hint,
          filled: true,
          fillColor: fillColor),
    );
  }
}
