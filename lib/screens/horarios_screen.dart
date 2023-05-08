import 'package:flutter/material.dart';
import 'package:horarios_web/subScreens/horarios_guardados_screen.dart';
import 'package:horarios_web/subScreens/horarios_mantenimiento_screen.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({super.key, this.userId = 0});
  final int? userId;
  @override
  State<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: principalColor,
              child: TabBar(indicatorColor: resaltadoColor, tabs: const [
                Tab(
                  text: 'Reportes',
                  icon: Icon(Icons.history_edu),
                ),
                Tab(
                  text: 'Historial',
                  icon: Icon(Icons.history),
                ),
              ]),
            ),
            const Expanded(
              child: TabBarView(children: [
                Center(
                  child: HorariosMantenimiento(),
                ),
                Center(
                  child: HorariosGuardados(),
                ),
              ]),
            )
          ],
        ));
  }
}
