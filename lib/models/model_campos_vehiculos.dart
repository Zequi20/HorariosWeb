import 'package:flutter/material.dart';

class CamposVehiculos {
  final int rowId;
  final String nroController;
  final String tipoController;
  final String descripcionController;
  final String matriculaController;
  final String asientosController;

  factory CamposVehiculos.fromRow(List<DataRow> rows, int index) {
    return CamposVehiculos(
      int.parse((rows[index].cells[0].child as Text).data!),
      (rows[index].cells[1].child as Text).data!,
      (rows[index].cells[2].child as Text).data!,
      (rows[index].cells[3].child as Text).data!,
      (rows[index].cells[4].child as Text).data!,
      (rows[index].cells[5].child as Text).data!,
    );
  }
  CamposVehiculos(
      this.rowId,
      this.nroController,
      this.tipoController,
      this.descripcionController,
      this.matriculaController,
      this.asientosController);
}
