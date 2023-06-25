import 'package:flutter/material.dart';

class ModalRow extends StatefulWidget {
  const ModalRow({super.key, required this.child, required this.sideTitle});
  final Widget child;
  final String sideTitle;

  @override
  State<ModalRow> createState() => _ModalRowState();
}

class _ModalRowState extends State<ModalRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(widget.sideTitle)),
        Expanded(
          flex: 2,
          child: widget.child,
        ),
      ],
    );
  }
}
