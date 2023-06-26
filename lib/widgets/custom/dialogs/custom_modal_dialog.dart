import 'package:flutter/material.dart';

class CustomModalDialog extends StatefulWidget {
  final VoidCallback onAccept;
  final String title;
  final List<Widget> content;
  const CustomModalDialog(
      {super.key,
      required this.onAccept,
      required this.title,
      required this.content});

  @override
  State<CustomModalDialog> createState() => _CustomModalDialogState();
}

class _CustomModalDialogState extends State<CustomModalDialog> {
  var colorAccept = const MaterialStatePropertyAll(Colors.transparent);
  var colorCancel = const MaterialStatePropertyAll(Colors.transparent);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(25),
      actions: [
        FilledButton.icon(
            onFocusChange: (value) {
              if (value) {
                colorAccept = const MaterialStatePropertyAll(Colors.orange);
              } else {
                colorAccept =
                    const MaterialStatePropertyAll(Colors.transparent);
              }
              setState(() {});
            },
            style: ButtonStyle(backgroundColor: colorAccept),
            autofocus: true,
            onPressed: widget.onAccept,
            icon: const Icon(Icons.save),
            label: const Text(
              'Agregar',
            )),
        FilledButton.icon(
            onFocusChange: (value) {
              if (value) {
                colorCancel = const MaterialStatePropertyAll(Colors.orange);
              } else {
                colorCancel =
                    const MaterialStatePropertyAll(Colors.transparent);
              }
              setState(() {});
            },
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel),
            label: const Text(
              'Cancelar',
            ))
      ],
      scrollable: true,
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.height,
        child: Column(children: widget.content),
      ),
    );
  }
}
