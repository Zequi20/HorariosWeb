import 'package:flutter/material.dart';
import 'package:horarios_web/screens/choferes_screen.dart';

class DatosScreen extends StatefulWidget {
  const DatosScreen({super.key});

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
            const Expanded(
              child: TabBarView(children: [
                Center(child: ScreenChoferes()),
                Center(
                  child: Text('aqui van vehiculos'),
                ),
                Center(
                  child: Text('aqui van grupos'),
                )
              ]),
            )
          ],
        ));
  }
}
