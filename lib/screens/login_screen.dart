import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horarios_web/models/model_usuario.dart';
import 'package:horarios_web/screens/datos_screen.dart';
import 'package:horarios_web/screens/home_screen.dart';
import 'package:horarios_web/screens/horarios_screen.dart';

// ignore: unused_import
import '../models/model_empresa.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  var loginAlertColor = Colors.transparent;
  var userController = TextEditingController();
  var passController = TextEditingController();
  late User argumento;
  List<User> listaUsers = [];

  validar(String user, String pass) async {
    final response =
        await http.get(Uri.parse('http://190.52.165.206:3000/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      listaUsers = data
          .map((registro) =>
              User(registro['ID'], registro['NAME'], registro['PASS']))
          .toList();
    } else {
      throw Exception('Error al obtener registros');
    }
    if (comprobar(listaUsers, user, pass)) {
      if (mounted) {
        Navigator.of(context).pushNamed('principal', arguments: argumento);
      }
    } else {
      loginAlertColor = Colors.white;
      setState(() {});
    }
  }

  bool comprobar(List<User> lista, String user, String pass) {
    bool retorno = false;
    for (var element in lista) {
      if (element.nombre == user && element.clave == pass) {
        retorno = true;
        argumento = element;
      }
    }

    return retorno;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: principalColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            principalColor,
            gradPrincipalColor,
            principalColor
          ])),
          width: 500,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Divider(
                color: Colors.transparent,
                height: 42,
              ),
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Usuario',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              maxLength: 50,
                              controller: userController,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Ingrese nombre de usuario'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 12,
                        color: Colors.transparent,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Clave',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              obscureText: true,
                              maxLength: 50,
                              controller: passController,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Ingrese clave de usuario'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                'Los datos no coinciden, intente de nuevo',
                                style: TextStyle(color: loginAlertColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FilledButton.icon(
                                  onPressed: () {
                                    validar(userController.text,
                                        passController.text);
                                  },
                                  icon: const Icon(Icons.key),
                                  label: const Text(
                                    'Validar',
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
          'REPORTES EMPRESA GUAIREÑA',
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
