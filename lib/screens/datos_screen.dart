import 'package:flutter/material.dart';
import 'package:horarios_web/subScreens/choferes_screen.dart';
import 'package:horarios_web/subScreens/grupos_screen.dart';
import 'package:horarios_web/widgets/tab_title.dart';

import '../subScreens/vehiculos_screen.dart';

class DatosScreen extends StatefulWidget {
  const DatosScreen({super.key, this.userId = 0});
  final int? userId;
  @override
  State<DatosScreen> createState() => _DatosScreenState();
}

class _DatosScreenState extends State<DatosScreen> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: gradPrincipalColor,
              child: TabBar(indicatorColor: resaltadoColor, tabs: const [
                Tab(
                  child: TabTitle(
                      iconoTitulo: Icon(Icons.supervisor_account),
                      titulo: 'Choferes'),
                ),
                Tab(
                  child: TabTitle(
                      iconoTitulo: Icon(Icons.car_rental), titulo: 'Coches'),
                ),
                Tab(
                  child: TabTitle(
                      iconoTitulo: Icon(Icons.mode_of_travel),
                      titulo: 'Grupos'),
                )
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                Center(
                    child: ScreenChoferes(
                  userId: widget.userId,
                )),
                Center(
                  child: ScreenVehiculos(
                    userId: widget.userId,
                  ),
                ),
                Center(
                  child: ScreenGrupos(
                    userId: widget.userId,
                  ),
                )
              ]),
            )
          ],
        ));
  }
}
