import 'package:flutter/material.dart';

class CustomDropDrown extends StatefulWidget {
  const CustomDropDrown({
    super.key,
    required this.dataController,
    required this.label,
    required this.options,
  });
  final List<String> options;
  final TextEditingController dataController;

  final String label;
  @override
  State<CustomDropDrown> createState() => _CustomDropDrownState();
}

class _CustomDropDrownState<T> extends State<CustomDropDrown> {
  Color fondoColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        isExpanded: true,
        value: widget.dataController.text,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 7)),
            hintText: widget.label,
            filled: true,
            fillColor: fondoColor),
        items: widget.options
            .map((e) => DropdownMenuItem(
                  value: e[0].toUpperCase(),
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: (e) {
          widget.dataController.text = e!;
          setState(() {});
        });
  }
}