import 'package:flutter/material.dart';

class ScreenGrupos extends StatefulWidget {
  const ScreenGrupos({super.key});

  @override
  State<ScreenGrupos> createState() => _ScreenGruposState();
}

class _ScreenGruposState extends State<ScreenGrupos>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: const [
        Text('aqui van grupos'),
        TextField(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
