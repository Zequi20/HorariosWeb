import 'package:flutter/material.dart';

class ScreenVehiculos extends StatefulWidget {
  const ScreenVehiculos({super.key});

  @override
  State<ScreenVehiculos> createState() => _ScreenVehiculosState();
}

class _ScreenVehiculosState extends State<ScreenVehiculos>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: const [
        Text('aqui van vehiculos'),
        TextField(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
