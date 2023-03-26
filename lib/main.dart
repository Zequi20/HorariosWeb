import 'package:flutter/material.dart';
import 'package:horarios_web/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HorariosWeb',
      home: Pantalla(),
    );
  }
}

class Pantalla extends StatelessWidget {
  const Pantalla({super.key});

  @override
  Widget build(BuildContext context) {
    var principalColor = const Color.fromARGB(255, 99, 1, 1);
    var resaltadoColor = Colors.orange;
    return MaterialApp(
      theme: ThemeData(
          tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.white, labelColor: resaltadoColor),
          navigationRailTheme: NavigationRailThemeData(
              useIndicator: true,
              indicatorColor: Colors.black12,
              unselectedLabelTextStyle: const TextStyle(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: principalColor,
              selectedLabelTextStyle: TextStyle(color: resaltadoColor),
              selectedIconTheme: IconThemeData(color: resaltadoColor)),
          appBarTheme: AppBarTheme(backgroundColor: principalColor)),
      debugShowCheckedModeBanner: false,
      title: 'Guaireña Horarios',
      routes: {
        'principal': (context) => const MainScreen(),
      },
      initialRoute: 'principal',
    );
  }
}
