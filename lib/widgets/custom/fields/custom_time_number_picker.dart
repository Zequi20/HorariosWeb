import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTimeNumberPicker extends StatefulWidget {
  const CustomTimeNumberPicker(
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
  State<CustomTimeNumberPicker> createState() => _CustomTimeNumberPickerState();
}

class _CustomTimeNumberPickerState extends State<CustomTimeNumberPicker> {
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
              textAlign: TextAlign.center,
              onChanged: (value) {
                int valor = int.parse(value);
                if (valor > widget.max) {
                  widget.textController.text = widget.max.toString();
                }
                if (valor < 10) {
                  widget.textController.text = '0$valor';
                }
                setState(() {});
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
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 7)),
                  hintText: widget.hint,
                  filled: true,
                  fillColor: fillColor),
            ),
          ),
          FittedBox(
            child: Container(
              width: 30,
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  ExcludeFocus(
                    excluding: true,
                    child: IconButton(
                        focusColor: Colors.orange,
                        onPressed: () {
                          if (pickerValue < widget.max) {
                            setState(() {
                              pickerValue++;
                              widget.textController.text =
                                  getTimeValue(pickerValue);
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_drop_up,
                          size: 15,
                        )),
                  ),
                  ExcludeFocus(
                    excluding: true,
                    child: IconButton(
                        focusColor: Colors.orange,
                        onPressed: () {
                          if (pickerValue > 0) {
                            setState(() {
                              pickerValue--;
                              widget.textController.text =
                                  getTimeValue(pickerValue);
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 15,
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}