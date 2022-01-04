import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';

class GenericTableDTS extends DataTableSource {
  final List<dynamic> data;
  final List<DTColumn> columns;
  final BuildContext context;
  GenericTableDTS({
    required this.data,
    required this.columns,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    final d = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        ...columns.map((c) {
          if (c.widget != null) {
            return DataCell(c.widget!(d));
          }
          return DataCell(
            Text(d[c.dataAttribute]),
          );
        })
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
