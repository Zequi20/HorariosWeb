import 'package:flutter/material.dart';

class CamposGrupos {
  final int rowId;

  final String nombre;
  final List<String> empresa;
  final String descripcion;
  final String km;

  factory CamposGrupos.fromRow(List<DataRow> rows, int index) {
    String idEmpresa = (rows[index].cells[2].child as Text)
        .key
        .toString()
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('\'', '');
    return CamposGrupos(
      int.parse((rows[index].cells[0].child as Text).data!),
      (rows[index].cells[1].child as Text).data!,
      [idEmpresa, (rows[index].cells[2].child as Text).data!],
      (rows[index].cells[3].child as Text).data!,
      (rows[index].cells[5].child as Text).data!,
    );
  }
  CamposGrupos(
      this.rowId, this.nombre, this.empresa, this.descripcion, this.km);
}
