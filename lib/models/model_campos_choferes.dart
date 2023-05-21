import 'package:flutter/material.dart';

class CamposChoferes {
  final int id;
  final String fechaNac;
  final String fechaAlta;
  final String codigo;
  final String nombre;
  final String documento;
  final String registro;
  final String direccion;
  final String telefono;
  final String tipo;
  final String estado;
  CamposChoferes(
      this.id,
      this.fechaNac,
      this.fechaAlta,
      this.codigo,
      this.nombre,
      this.documento,
      this.registro,
      this.direccion,
      this.telefono,
      this.tipo,
      this.estado);
  factory CamposChoferes.fromRow(List<DataRow> rows, int index) {
    return CamposChoferes(
        int.parse((rows[index].cells[0].child as Text).data!),
        (rows[index].cells[6].child as Text).data!,
        (rows[index].cells[11].child as Text).data!,
        (rows[index].cells[1].child as Text).data!,
        (rows[index].cells[3].child as Text).data!,
        (rows[index].cells[4].child as Text).data!,
        (rows[index].cells[5].child as Text).data!,
        (rows[index].cells[8].child as Text).data!,
        (rows[index].cells[9].child as Text).data!,
        (rows[index].cells[2].child as Text).data!,
        (rows[index].cells[7].child as Text).data!);
  }
}
