import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  const TabTitle({super.key, required this.iconoTitulo, required this.titulo});
  final Icon iconoTitulo;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconoTitulo,
          const Divider(
            indent: 5,
            color: Colors.transparent,
          ),
          Text(titulo)
        ],
      ),
    );
  }
}
