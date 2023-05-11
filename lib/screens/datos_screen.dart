import 'package:flutter/material.dart';
import 'package:horarios_web/subScreens/choferes_screen.dart';
import 'package:horarios_web/subScreens/grupos_screen.dart';

import '../subScreens/vehiculos_screen.dart';

class DatosScreen extends StatefulWidget {
  const DatosScreen({super.key, this.userId = 0});
  final int? userId;
  @override
  State<DatosScreen> createState() => _DatosScreenState();
}

class _DatosScreenState extends State<DatosScreen> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: principalColor,
              child: TabBar(indicatorColor: resaltadoColor, tabs: const [
                Tab(
                  text: 'Choferes',
                  icon: Icon(Icons.account_circle_rounded),
                ),
                Tab(
                  text: 'Vehiculos',
                  icon: Icon(Icons.drive_eta),
                ),
                Tab(
                  text: 'Grupos',
                  icon: Icon(Icons.view_timeline_sharp),
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
