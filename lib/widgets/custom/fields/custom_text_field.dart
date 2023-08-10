import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    required this.hint,
    this.expand = false,
    this.lenght = 50,
    this.numeric = false,
    this.icon = Icons.abc,
  });
  final TextEditingController textController;
  final String hint;
  final int? lenght;
  final bool numeric;
  final bool expand;
  final IconData icon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode foco = FocusNode();
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);

  Color fillColor = Colors.white70;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.expand ? null : 1,
      maxLines: widget.expand ? null : 1,
      expands: widget.expand,
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
