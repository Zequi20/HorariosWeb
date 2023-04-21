import 'package:flutter/material.dart';

class HorariosMantenimiento extends StatefulWidget {
  const HorariosMantenimiento({super.key});

  @override
  State<HorariosMantenimiento> createState() => _HorariosMantenimientoState();
}

class _HorariosMantenimientoState extends State<HorariosMantenimiento>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      body: Center(
        child: Text(
            'AQUI VA EL FORMULARIO PARA EDITAR Y HACER REPORTE DE LOS HORARIOS DE TODOS LOS GRUPOS QUE SE HAYAN CREADO'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
