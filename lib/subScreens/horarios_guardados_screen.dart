import 'package:flutter/material.dart';

class HorariosGuardados extends StatefulWidget {
  const HorariosGuardados({super.key});

  @override
  State<HorariosGuardados> createState() => _HorariosGuardadosState();
}

class _HorariosGuardadosState extends State<HorariosGuardados> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
            'Aca se muestra el historial de reportes de horarios emitidos'),
      ),
    );
  }
}
