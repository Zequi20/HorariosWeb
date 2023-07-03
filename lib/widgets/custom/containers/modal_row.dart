import 'package:flutter/material.dart';

class ModalRow extends StatefulWidget {
  const ModalRow({
    super.key,
    required this.sideTitle,
    required this.child,
  });
  final Widget child;
  final String sideTitle;

  @override
  State<ModalRow> createState() => _ModalRowState();
}

class _ModalRowState extends State<ModalRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
              child: Text(
            widget.sideTitle,
            style: const TextStyle(fontSize: 20),
          )),
          Expanded(
            flex: 2,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
