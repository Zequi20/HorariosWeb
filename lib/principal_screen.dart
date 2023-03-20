import 'package:flutter/material.dart';

import 'models/model_empresa.dart';

class PantallaPrincipal extends StatefulWidget {
  PantallaPrincipal({super.key});
  final frontColor = Colors.white;
  final backColor = Colors.grey.shade50;
  final barColor = Colors.grey.shade300;
  final textColor = Colors.grey.shade800;
  final List<Empresa> empresas = [
    Empresa(1, 'Guairena'),
    Empresa(2, 'Yutena'),
    Empresa(3, 'Sanjuanina')
  ];
  final List<String> fechas = ['14/15/23', '14/15/22', '14/05/22', '10/12/21'];
  final titleStyle = TextStyle(color: Colors.grey.shade800);
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int empresa = 1;
  String fecha = '14/15/23';

  @override
  Widget build(BuildContext context) {
    var dropDownDecoration = InputDecoration(
        fillColor: widget.barColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Colors.black38)));
    var barTitle = Text(
      'Guaireña Horarios',
      style: widget.titleStyle,
    );
    var drawerWidth = MediaQuery.of(context).size.width / 6;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          width: drawerWidth,
          child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, i) {
                return drawerBuilder(context, i);
              }),
        ),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.abc),
              ),
              Tab(
                icon: Icon(Icons.abc),
              ),
              Tab(
                icon: Icon(Icons.abc),
              )
            ],
          ),
          iconTheme: IconThemeData(color: widget.textColor),
          toolbarHeight: 40,
          title: barTitle,
          backgroundColor: widget.barColor,
        ),
        backgroundColor: widget.backColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Horarios de salida',
                  style: widget.titleStyle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: DropdownButtonFormField(
                            decoration: dropDownDecoration,
                            alignment: Alignment.center,
                            value: empresa,
                            items: List.generate(
                                widget.empresas.length,
                                (index) => DropdownMenuItem(
                                    value: widget.empresas[index].idEmpresa,
                                    child: Text(
                                        widget.empresas[index].nombreEmpresa))),
                            onChanged: (val) {
                              setState(() {
                                empresa = val!;
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: DropdownButtonFormField(
                            decoration: dropDownDecoration,
                            alignment: Alignment.center,
                            value: fecha,
                            items: List.generate(
                                widget.fechas.length,
                                (index) => DropdownMenuItem(
                                    value: widget.fechas[index],
                                    child: Text(widget.fechas[index]))),
                            onChanged: (val) {
                              setState(() {
                                fecha = val!;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.barColor,
                            border: Border.all(color: Colors.black38)),
                        child: Text(
                          'ID: 12323',
                          style: widget.titleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            focusColor: widget.barColor,
                            hoverColor: widget.barColor,
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  color: widget.barColor,
                                  border: Border.all(color: Colors.black38)),
                              child: Center(
                                child: Text(
                                  'Opciones',
                                  style: widget.titleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 18),
                                    child: InkWell(
                                      focusColor: widget.barColor,
                                      hoverColor: widget.barColor,
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: widget.barColor,
                                            border: Border.all(
                                                color: Colors.black38)),
                                        child: Center(
                                          child: Text(
                                            'Modificar horario',
                                            style: widget.titleStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 18),
                                    child: InkWell(
                                      focusColor: widget.barColor,
                                      hoverColor: widget.barColor,
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: widget.barColor,
                                            border: Border.all(
                                                color: Colors.black38)),
                                        child: Center(
                                          child: Text(
                                            'Extraer horario',
                                            style: widget.titleStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget? drawerBuilder(context, i) {
    return ListTile(
      title: Text(
        'Opcion $i',
        style: widget.titleStyle,
      ),
    );
  }
}
