import 'package:flutter/material.dart';

class HorariosScreen extends StatefulWidget {
  const HorariosScreen({super.key});

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
                  text: 'Horarios Guardados',
                  icon: Icon(Icons.timelapse),
                ),
                Tab(
                  text: 'Mantenimiento',
                  icon: Icon(Icons.edit_square),
                ),
              ]),
            ),
            const Expanded(
              child: TabBarView(children: [
                Center(
                  child: Text('aqui van horarios'),
                ),
                Center(
                  child: Text('aqui van opciones de mantenimiento'),
                ),
              ]),
            )
          ],
        ));
  }
}
