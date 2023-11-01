import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTimeNumberPicker extends StatefulWidget {
  const SimpleTimeNumberPicker(
      {super.key,
      required this.textController,
      required this.hint,
      this.lenght = 50,
      this.numeric = false,
      this.initialValue = 1,
      required this.max,
      this.icon = Icons.numbers});
  final TextEditingController textController;
  final String hint;
  final int lenght;
  final int initialValue;
  final bool numeric;
  final int max;
  final IconData icon;

  @override
  State<SimpleTimeNumberPicker> createState() => _SimpleTimeNumberPickerState();
}

class _SimpleTimeNumberPickerState extends State<SimpleTimeNumberPicker> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  FocusNode foco = FocusNode();
  Color fillColor = Colors.transparent;
  late int pickerValue;
  @override
  void initState() {
    super.initState();
    pickerValue = widget.initialValue;
    widget.textController.text = getTimeValue(pickerValue);
    foco.addListener(() {
      String value = widget.textController.text;
      if (!foco.hasFocus) {
        if (value.isEmpty) {
          widget.textController.text = '00';
        } else {
          if (int.parse(value) > widget.max) {
            widget.textController.text = '00';
          }
          if (value.length < 2) {
            widget.textController.text = '0$value';
          }
        }
      } else {
        widget.textController.selection = TextSelection(
            baseOffset: 0, extentOffset: widget.textController.text.length);
      }
    });
  }

  String getTimeValue(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: TextFormField(
              autofocus: true,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[0-9]{0,2}$')), // Limitar a 2 dígitos
                FilteringTextInputFormatter.digitsOnly,
              ],
              focusNode: foco,
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(foco);
              },
              controller: widget.textController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 7)),
                  hintText: widget.hint,
                  filled: true,
                  fillColor: fillColor),
            ),
          ),
        ],
      ),
    );
  }

  void disminuir() {
    if (pickerValue > 0) {
      setState(() {
        pickerValue--;
        widget.textController.text = getTimeValue(pickerValue);
      });
    }
  }

  void aumentar() {
    if (pickerValue < widget.max) {
      setState(() {
        pickerValue++;
        widget.textController.text = getTimeValue(pickerValue);
      });
    }
  }
}
