import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horarios_web/models/model_campos_choferes.dart';
import 'package:horarios_web/widgets/modals/chofer/modal_agregar_chofer.dart';
import 'package:horarios_web/widgets/modals/chofer/modal_editar_chofer.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenChoferes extends StatefulWidget {
  const ScreenChoferes({super.key, this.userId = 0});
  final int? userId;

  @override
  State<ScreenChoferes> createState() => _ScreenChoferesState();
}

class _ScreenChoferesState extends State<ScreenChoferes>
    with AutomaticKeepAliveClientMixin {
  final verticalController = ScrollController();
  final horizontalController = ScrollController();

  DateTime curDate = DateTime.now();
  FocusNode foco = FocusNode();
  var principalColor = const Color.fromARGB(255, 99, 1, 1);
  var gradPrincipalColor = const Color.fromARGB(255, 136, 2, 2);
  var resaltadoColor = Colors.orange;
  int valorTipo = 0;
  List<DataRow> rows = [];
  int searchIndex = 0;
  bool titleVisible = true;

  List<int> selectedRows = [];
  List<DropdownMenuItem<int>> itemList = const [
    DropdownMenuItem(
      value: 0,
      child: Text('Id', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('Codigo', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('Tipo', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('Nombre', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('Documento', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 5,
      child: Text('Registro', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 6,
      child: Text('Nacimiento', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 7,
      child: Text('Estado Civil', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 8,
      child: Text('Direccion', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 9,
      child: Text('Telefono', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 10,
      child: Text('Usuario', overflow: TextOverflow.ellipsis),
    ),
    DropdownMenuItem(
      value: 11,
      child: Text('Alta', overflow: TextOverflow.ellipsis),
    )
  ];

  DateFormat dateFormatter = DateFormat('dd/MM/yyy');
  var deleteController = TextEditingController();
  var searchController = TextEditingController();

  String getTipoChofer(String letra) {
    String tipo = '';
    if (letra == 'C' || letra == '1') {
      tipo = 'Chofer';
    } else if (letra == 'G' || letra == '0') {
      tipo = 'Guarda';
    } else {
      tipo = 'Indefinido';
    }
    return tipo;
  }

  String getEstadoCivil(String letra) {
    String tipo = '';
    if (letra == 'C' || letra == '1') {
      tipo = 'Casado';
    } else if (letra == 'S' || letra == '0') {
      tipo = 'Soltero';
    } else {
      tipo = 'Indefinido';
    }
    return tipo;
  }

  String formatId(List<int> lista) {
    return lista
        .map((e) => (rows[e].cells[0].child as Text).data)
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "");
  }

  void deleteReg() async {
    var requestPost = http.Request(
        'DELETE', Uri.parse('http://190.52.165.206:3000/delete_drivers'));

    String idList = formatId(selectedRows);

    requestPost.bodyFields = {'id': idList};
    http.StreamedResponse responseStream = await requestPost.send();

    if (responseStream.statusCode == 200) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Operacion exitosa'),
                content: const Text('Operacion realizada con exito :)'),
                actions: [
                  TextButton(
                    style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                      setState(() {
                        selectedRows.clear();
                      });
                    },
                  ),
                ],
              );
            });
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop(true);
        msgBox('Error', 'Algo ha salido mal');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    foco.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: gradPrincipalColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 55,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIconColor: Colors.black54,
                              hintText: 'Filtrar',
                              suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 55,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        isExpanded: true,
                        focusColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        menuMaxHeight: 256,
                        value: searchIndex,
                        items: itemList,
                        onChanged: (int? value) {
                          searchIndex = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  CallbackShortcuts(
                    bindings: <ShortcutActivator, VoidCallback>{
                      const SingleActivator(LogicalKeyboardKey.keyA): () {
                        onAdd();
                      },
                      const SingleActivator(LogicalKeyboardKey.keyE): () {
                        onEdit();
                      },
                      const SingleActivator(LogicalKeyboardKey.keyR): () {
                        onDelete();
                      },
                    },
                    child: Focus(
                      focusNode: foco,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          position: PopupMenuPosition.under,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: resaltadoColor)),
                          splashRadius: 18,
                          icon: Icon(
                            Icons.construction,
                            fill: 1,
                            color: resaltadoColor,
                          ),
                          iconSize: 32,
                          tooltip: 'Acciones',
                          itemBuilder: (BuildContext context) {
                            return [
                              TextButton.icon(
                                onPressed: onAdd,
                                icon: Icon(
                                  Icons.person_add,
                                  color: gradPrincipalColor,
                                ),
                                label: Text(
                                  'Agregar (a)',
                                  style: TextStyle(color: principalColor),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: onDelete,
                                icon: Icon(Icons.person_remove,
                                    color: gradPrincipalColor),
                                label: Text(
                                  'Remover (r)',
                                  style: TextStyle(color: principalColor),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: onEdit,
                                icon: Icon(
                                  Icons.mode_edit,
                                  color: gradPrincipalColor,
                                ),
                                label: Text(
                                  'Editar (e)',
                                  style: TextStyle(color: principalColor),
                                ),
                              )
                            ].map((e) {
                              return PopupMenuItem(
                                child: e,
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: horizontalController,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 14,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: FutureBuilder(
                    future: fetchRows(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (searchController.text.trim().isEmpty) {
                          rows = snapshot.data!;
                        } else {
                          rows = snapshot.data!.where((row) {
                            String rowText =
                                (row.cells[searchIndex].child as Text)
                                    .data!
                                    .toLowerCase();
                            String searchTerm =
                                searchController.text.toLowerCase();
                            return rowText.contains(searchTerm);
                          }).toList();
                        }
                        return SingleChildScrollView(
                          controller: verticalController,
                          scrollDirection: Axis.vertical,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: principalColor),
                            child: DataTable(
                              onSelectAll: (value) {
                                setState(() {
                                  if (value! == true) {
                                    selectedRows.addAll(rows
                                        .map((e) => rows.indexOf(e))
                                        .toList());
                                  } else {
                                    selectedRows.clear();
                                  }
                                });
                              },
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Codigo')),
                                DataColumn(label: Text('Tipo')),
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Documento')),
                                DataColumn(label: Text('Registro')),
                                DataColumn(label: Text('Nacimiento')),
                                DataColumn(label: Text('Estado Civil')),
                                DataColumn(label: Text('Direccion')),
                                DataColumn(label: Text('Telefono')),
                                DataColumn(label: Text('Usuario')),
                                DataColumn(label: Text('Alta'))
                              ],
                              rows: rows,
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DataRow>> fetchRows() async {
    List<DataRow> fetched = [];
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
      'Access-Control-Allow-Headers': 'Content-Type',
    };
    var request =
        http.Request('GET', Uri.parse('http://190.52.165.206:3000/DRIVERS'));
    request.headers.addAll(headers);
    http.StreamedResponse responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    List jsonResponse = json.decode(response.body);

    for (var i = 0; i < jsonResponse.length; i++) {
      fetched.add(DataRow(
          selected: selectedRows.contains(i),
          onSelectChanged: (value) {
            if (value! == true) {
              selectedRows.add(i);
            } else {
              selectedRows.remove(i);
            }
            setState(() {});
          },
          cells: [
            DataCell(Text(jsonResponse[i]['ID'].toString())),
            DataCell(Text(jsonResponse[i]['CODE'].toString())),
            DataCell(Text(getTipoChofer(jsonResponse[i]['TYPE']))),
            DataCell(Text(jsonResponse[i]['NAME'])),
            DataCell(Text(jsonResponse[i]['CI'].toString().trim())),
            DataCell(
                Text(jsonResponse[i]['DRIVING_LICENSE'].toString().trim())),
            DataCell(Text(dateFormatter
                .format(DateTime.tryParse(jsonResponse[i]['BIRTH_DATE'])!))),
            DataCell(Text(getEstadoCivil(
                jsonResponse[i]['MARITAL_STATUS'].toString().trim()))),
            DataCell(Text(jsonResponse[i]['ADDRESS'].toString().trim())),
            DataCell(Text(jsonResponse[i]['PHONE'].toString().trim())),
            DataCell(Text(jsonResponse[i]['USUARIO'].toString().trim())),
            DataCell(
              Text(dateFormatter.format(
                  DateTime.tryParse(jsonResponse[i]['DISCHARGE_DATE'])!)),
            )
          ]));
    }
    return fetched;
  }

//{"ID","TYPE","NAME","CI","DRIVING_LICENSE","BIRTH_DATE","MARITAL_STATUS","ADDRESS","PHONE","USUARIO","DISCHARGE_DATE""}
  @override
  bool get wantKeepAlive => false;

  void onDelete() {
    if (selectedRows.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Eliminar registro'),
            content: Wrap(
              children: [
                Text(
                    'Seguro que desea eliminar ${selectedRows.length} ${selectedRows.length > 1 ? 'registros' : 'registro'}?')
              ],
            ),
            actions: [
              TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Si, continuar'),
                onPressed: () {
                  deleteReg();
                },
              ),
              TextButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        },
      );
    } else {
      msgBox('Remover elemento',
          'Debe seleccionar uno o mas elementos de la lista primero');
    }
  }

  void onAdd() async {
    await showDialog(
        context: context,
        builder: (context) {
          return ModalAgregarChofer(
            userId: widget.userId,
          );
        });
    setState(() {});
  }

  void onEdit() async {
    if (selectedRows.isNotEmpty && selectedRows.length < 2) {
      CamposChoferes campos = CamposChoferes.fromRow(rows, selectedRows.first);
      await showDialog(
          context: context,
          builder: (context) {
            return ModalEditarChofer(
              rowId: campos.id,
              userId: widget.userId,
              codigo: campos.codigo,
              direccion: campos.direccion,
              documento: campos.documento,
              estado: campos.estado,
              fechaAlta: campos.fechaAlta,
              fechaNac: campos.fechaNac,
              nombre: campos.nombre,
              registro: campos.registro,
              telefono: campos.telefono,
              tipo: campos.tipo,
            );
          });
      setState(() {
        selectedRows.clear();
      });
    } else {
      msgBox(
          'Editar elemento',
          selectedRows.isEmpty
              ? 'Usted no ha seleeccionado ningun elemento'
              : 'Seleccione un unico elemento');
    }
  }

  Future<void> msgBox(String title, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                autofocus: true,
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
