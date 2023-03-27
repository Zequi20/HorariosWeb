import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with AutomaticKeepAliveClientMixin {
  String usuario = 'usuario';
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Text('Bienvenido! $usuario'),
        TextField(
          onChanged: (value) {
            setState(() {
              usuario = value;
            });
          },
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
