import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key, this.userId = 0, this.userName = ''});
  final int? userId;
  final String? userName;
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with AutomaticKeepAliveClientMixin {
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Card(
            color: Colors.transparent,
            elevation: 20,
            margin: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    principalColor,
                    gradPrincipalColor,
                    principalColor
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Bienvenido ${widget.userName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Icon(
                Icons.history_edu,
                size: 55,
              ),
              Divider(
                indent: 30,
              ),
              Text(
                '4587 reportes generados en total',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Icon(
                Icons.handshake,
                size: 55,
              ),
              Divider(
                indent: 30,
              ),
              Text(
                '2304 han sido generados por ti',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
