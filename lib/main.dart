import 'package:flutter/material.dart';
import 'package:horarios_web/screens/login_screen.dart';
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
    //var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
    return MaterialApp(
      theme: ThemeData(
          dialogTheme: const DialogTheme(
              titleTextStyle: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              contentTextStyle: TextStyle(color: Colors.white)),
          dialogBackgroundColor: principalColor,
          filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                  iconColor: const MaterialStatePropertyAll(Colors.white),
                  side: const MaterialStatePropertyAll(
                      BorderSide(color: Colors.white)),
                  backgroundColor: MaterialStatePropertyAll(principalColor))),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: principalColor),
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            counterStyle: TextStyle(color: Colors.white),
          ),
          tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.white, labelColor: resaltadoColor),
          navigationRailTheme: NavigationRailThemeData(
              useIndicator: true,
              indicatorColor: principalColor,
              unselectedLabelTextStyle: const TextStyle(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.white),
              selectedLabelTextStyle: TextStyle(color: resaltadoColor),
              selectedIconTheme: IconThemeData(color: resaltadoColor)),
          appBarTheme: AppBarTheme(backgroundColor: principalColor)),
      debugShowCheckedModeBanner: false,
      title: 'Guaireña Horarios',
      routes: {
        'principal': (context) => const MainScreen(),
        'login': (context) => const LoginScreen(),
      },
      initialRoute: 'principal',
    );
  }
}
