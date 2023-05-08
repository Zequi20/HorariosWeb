import 'package:flutter/material.dart';
import 'package:horarios_web/screens/datos_screen.dart';
import 'package:horarios_web/screens/home_screen.dart';
import 'package:horarios_web/screens/horarios_screen.dart';

// ignore: unused_import
import '../models/model_empresa.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.userId = 0});
  final int? userId;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 1;
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  bool extended = true;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      extended = false;
    } else {
      extended = true;
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            minExtendedWidth: 150,
            elevation: 5,
            extended: extended,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Inicio')),
              NavigationRailDestination(
                  icon: Icon(Icons.edit_note), label: Text('Datos')),
              NavigationRailDestination(
                  icon: Icon(Icons.access_time), label: Text('Horarios')),
              NavigationRailDestination(
                  icon: Icon(Icons.login), label: Text('Salir')),
            ],
            selectedIndex: selected,
            onDestinationSelected: (int index) {
              setState(() {
                selected = index;
              });
            },
          ),
          Expanded(
            child: screenBuilder(selected),
          )
        ],
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                principalColor,
                gradPrincipalColor,
                principalColor
              ])),
        ),
        title: const Text(
          'Guairena Horarios',
        ),
        elevation: 0,
      ),
    );
  }

  Widget screenBuilder(int index) {
    if (index == 1) {
      return const DatosScreen();
    } else if (index == 2) {
      return const HorariosScreen();
    } else if (index == 0) {
      return const ScreenHome();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Pantalla en desarrollo',
          ),
          Text(
            'Esta pantalla se encuentra en desarrollo',
          ),
        ],
      );
    }
  }
}
