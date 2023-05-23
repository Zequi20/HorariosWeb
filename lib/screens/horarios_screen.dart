import 'package:flutter/material.dart';
import 'package:horarios_web/subScreens/horarios_historial_screen.dart';
import 'package:horarios_web/subScreens/horarios_mantenimiento_screen.dart';
import 'package:horarios_web/widgets/tab_title.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({super.key, this.userId = 0});
  final int? userId;
  @override
  State<HorariosScreen> createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: gradPrincipalColor,
              child: TabBar(indicatorColor: resaltadoColor, tabs: const [
                Tab(
                  child: TabTitle(
                      iconoTitulo: Icon(Icons.history_edu), titulo: 'Reportes'),
                ),
                Tab(
                  child: TabTitle(
                      iconoTitulo: Icon(Icons.history), titulo: 'Historial'),
                ),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                Center(
                  child: HorariosMantenimiento(
                    userId: widget.userId,
                  ),
                ),
                Center(
                  child: HorariosGuardados(
                    userId: widget.userId,
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}
