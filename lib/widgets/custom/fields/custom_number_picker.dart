import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberPicker extends StatefulWidget {
  const CustomNumberPicker(
      {super.key,
      required this.textController,
      required this.hint,
      this.lenght = 50,
      this.numeric = false,
      this.initialValue = 1,
      required this.max});
  final TextEditingController textController;
  final String hint;
  final int lenght;
  final int initialValue;
  final bool numeric;
  final int max;

  @override
  State<CustomNumberPicker> createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  FocusNode foco = FocusNode();
  Color fillColor = Colors.white;
  late int pickerValue;
  @override
  void initState() {
    super.initState();
    pickerValue = widget.initialValue;
    widget.textController.text = pickerValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: TextFormField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (int.parse(value) > widget.max) {
                  setState(() {
                    widget.textController.text = widget.max.toString();
                  });
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              focusNode: foco,
              onFieldSubmitted: (value) {
                if (int.parse(value) > widget.max) {
                  setState(() {
                    widget.textController.text = widget.max.toString();
                  });
                }
                FocusScope.of(context).requestFocus(foco);
              },
              controller: widget.textController,
              decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 7)),
                  hintText: widget.hint,
                  filled: true,
                  fillColor: fillColor),
            ),
          ),
          const Divider(
            indent: 4,
          ),
          FittedBox(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        if (pickerValue < widget.max) {
                          setState(() {
                            pickerValue++;
                            widget.textController.text = pickerValue.toString();
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_drop_up)),
                  IconButton(
                      onPressed: () {
                        if (pickerValue > 0) {
                          setState(() {
                            pickerValue--;
                            widget.textController.text = pickerValue.toString();
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_drop_down))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
