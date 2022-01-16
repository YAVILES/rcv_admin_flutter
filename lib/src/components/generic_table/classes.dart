import 'dart:convert';

import 'package:flutter/material.dart';

enum TypeColumn {
  dateTime,
}

class DTFilterField {
  String? value;
  String? description;
  DTFilterField({
    this.value,
    this.description,
  });
}

class DTColumn {
  /// Ancho de la columna */
  int? width;

  /// Ancho de la columna */
  double? height;

  /// Atributo que se consultará al backend, por defecto attribute */
  String dataAttribute;

  /// Atributo que se mostrará en la columna */
  String? attribute;

  /// Cabecera de la columna, por defecto title case de attribute */
  String? header;

  /// Ruta para el routerLink del enlace de la columna */
  String? routerLink;

  /// Atributo que se pasa como parámetro al routerLink, por defecto id */
  String? routerLinkAttribute;

  /// Tipo de columna. Por defecto text */
  TypeColumn? type;

  /// Formato de fecha de la columna. Por defecto defaultDateFormat */
  String? dateFormat;

  /// Clave del diccionario de plantillas de donde se extrae el widget para la columna
  Widget Function(Map<String, dynamic> item)? widget;

  ///Definir si la columna se puede ordenar o no
  bool? onSort;

  /// Acortar uuid de la columna (sólo válido para columnas con UUID)
  bool? shortUUID;

  /// Css que se aplica a td de la columna */
  String? className;

  /// Separador de elementos de un array a mostrar en el excel */
  String? separatorExcelColumn;

  /// Define si un elemento (columna) tiene como valor un object */
  bool? objectExcelColumn;

  /// Define que propiedad del objeto de una columna se mostrará en el excel
  /// (Funciona solo si el atributo objectExcelColumn esta) */
  String? propertyObjectExcelColumn;

  /// Define si a la columna se le oculta el filtro o no */
  bool? hideFilter;

  DTColumn({
    this.width,
    this.height,
    required this.dataAttribute,
    this.attribute,
    this.header,
    this.routerLink,
    this.routerLinkAttribute,
    this.type,
    this.dateFormat,
    this.widget,
    this.onSort,
    this.shortUUID,
    this.className,
    this.separatorExcelColumn,
    this.objectExcelColumn,
    this.propertyObjectExcelColumn,
    this.hideFilter,
  }) {
    onSort = onSort ?? true;
  }
}

class DTFilter {
  /// Tipo de input, por defecto html  'select' | 'html' | 'range' | 'callable'*/
  String? type;

  /// Subtipo de input, válido cuando type es html o range 'date' | 'number' | 'text'*/
  String? dataType;

  /// Opciones en caso de que type sea select */
  List<dynamic>? options;

  /// Atributo con el valor que se muestra en el select */
  String? optionDisplayAttribute;

  /// Atributo con valor que se selecciona en el select */
  String? queoptionValueAttribute;
  DTFilter({
    this.type,
    this.dataType,
    this.options,
    this.optionDisplayAttribute,
    this.queoptionValueAttribute,
  });
}

class CheckChangeEvent {
  /// Items que cambiaron su valor */
  List<dynamic>? items;

  /// Nuevo valor del checkbox */
  bool? value;

  CheckChangeEvent({
    this.items,
    this.value,
  });
}

class DataSelectChange {
  int index;
  Map<String, dynamic> item;
  bool? select;

  DataSelectChange({
    required this.index,
    required this.item,
    this.select,
  });

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'item': item,
      'select': select,
    };
  }

  factory DataSelectChange.fromMap(Map<String, dynamic> map) {
    return DataSelectChange(
      index: map['index']?.toInt() ?? 0,
      item: Map<String, dynamic>.from(map['item']),
      select: map['select'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataSelectChange.fromJson(String source) =>
      DataSelectChange.fromMap(json.decode(source));
}
