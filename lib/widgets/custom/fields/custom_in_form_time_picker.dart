import 'package:flutter/material.dart';
import 'package:horarios_web/widgets/custom/fields/custom_time_number_picker.dart';

class InFormTimePicker extends StatefulWidget {
  const InFormTimePicker({super.key, required this.horaController});
  final TextEditingController horaController;
  @override
  State<InFormTimePicker> createState() => _InFormTimePickerState();
}

class _InFormTimePickerState extends State<InFormTimePicker> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  @override
  void initState() {
    super.initState();
    hourController.addListener(() {
      widget.horaController.text =
          '${hourController.text}:${minuteController.text}:00';
    });
    minuteController.addListener(() {
      widget.horaController.text =
          '${hourController.text}:${minuteController.text}:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.grey.shade300,
            Colors.grey.shade300,
            Colors.white,
            Colors.grey.shade300,
            Colors.grey.shade300
          ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            color: Color.fromARGB(255, 136, 2, 2),
          ),
          CustomTimeNumberPicker(
            textController: hourController,
            hint: '',
            max: 23,
            initialValue: 0,
          ),
          CustomTimeNumberPicker(
            textController: minuteController,
            hint: '',
            max: 59,
            initialValue: 0,
          )
        ],
      ),
    );
  }
}
