import 'package:flutter/material.dart';
import 'package:horarios_web/principal_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guaireña Horarios',
      routes: {
        'principal': (context) => PantallaPrincipal(),
      },
      initialRoute: 'principal',
    );
  }
}
