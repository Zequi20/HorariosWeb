import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusableWidget extends StatefulWidget {
  const FocusableWidget({super.key, required this.child});
  final Widget child;
  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  final FocusNode _focusNode = FocusNode();
  Color colorBorde = Colors.transparent;
  bool isExcluded = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 4, color: colorBorde)),
      child: Center(
        child: Focus(
          onKey: (node, event) {
            if (node.hasFocus &&
                event is RawKeyUpEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              excludeHandler();
            }

            return KeyEventResult.ignored;
          },
          onFocusChange: (value) {
            if (value) {
              setState(() {
                colorBorde = Colors.orange;
              });
            } else {
              setState(() {
                colorBorde = Colors.transparent;
              });
            }
          },
          focusNode: _focusNode,
          child: ExcludeFocus(
              excluding: isExcluded,
              child: FocusScope(autofocus: true, child: widget.child)),
        ),
      ),
    );
  }

  void excludeHandler() {
    if (isExcluded) {
      isExcluded = false;
      print(isExcluded);
    } else {
      isExcluded = true;
      print(isExcluded);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
