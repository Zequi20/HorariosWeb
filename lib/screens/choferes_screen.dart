import 'package:flutter/material.dart';

class ScreenChoferes extends StatefulWidget {
  const ScreenChoferes({super.key});

  @override
  State<ScreenChoferes> createState() => _ScreenChoferesState();
}

class _ScreenChoferesState extends State<ScreenChoferes>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: const [
        Text('aqui van choferes'),
        TextField(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
