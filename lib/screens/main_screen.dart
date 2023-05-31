import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_usuario.dart';
import 'package:horarios_web/screens/datos_screen.dart';
import 'package:horarios_web/screens/home_screen.dart';
import 'package:horarios_web/screens/horarios_screen.dart';

// ignore: unused_import
import '../models/model_empresa.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 0;
  bool isVisible = true;

  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;

  User? getUser() {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      return User(2, 'Zequi', '23424pelao');
    } else {
      return ModalRoute.of(context)?.settings.arguments as User;
    }
  }

  void visibilityCheck() {
    if (isVisible) {
      isVisible = false;
    } else {
      isVisible = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool extended = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1.0 : 00,
            child: Visibility(
              visible: isVisible,
              child: NavigationRail(
                backgroundColor: gradPrincipalColor,
                minExtendedWidth: 150,
                elevation: 5,
                extended: extended,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Inicio')),
                  NavigationRailDestination(
                      icon: Icon(Icons.edit_note), label: Text('Datos')),
                  NavigationRailDestination(
                      icon: Icon(Icons.note_add), label: Text('Reporte')),
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
            ),
          ),
          Expanded(
            child: screenBuilder(selected),
          )
        ],
      ),
      appBar: AppBar(
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
        leading: IconButton(
            tooltip: 'desplegar/ocultar navegacion',
            onPressed: () {
              visibilityCheck();
              setState(() {});
            },
            icon: const Icon(Icons.menu)),
        toolbarHeight: 38,
        title: const Text(
          'Reporte horarios',
        ),
        elevation: 0,
      ),
    );
  }

  Widget screenBuilder(int index) {
    if (index == 1) {
      return DatosScreen(
        userId: getUser()?.id,
      );
    } else if (index == 2) {
      return HorariosScreen(
        userId: getUser()?.id,
      );
    } else if (index == 0) {
      return ScreenHome(
        userId: getUser()?.id,
        userName: getUser()?.nombre,
      );
    } else {
      return const Center(
        child: Text('En desarrollo'),
      );
    }
  }
}
