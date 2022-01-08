import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:intl/intl.dart';

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
          if (c.type == TypeColumn.dateTime) {
            var formatterDate = DateFormat('yyyy-MM-dd');
            var formatterHour = DateFormat('h:mm:ss a');
            return DataCell(
              d[c.dataAttribute] != null
                  ? Column(
                      children: [
                        Text(
                          formatterDate.format(
                            DateTime.parse(d[c.dataAttribute]),
                          ),
                        ),
                        Text(
                          formatterHour.format(
                            DateTime.parse(d[c.dataAttribute]),
                          ),
                        ),
                      ],
                    )
                  : const Text('N/A'),
            );
          }
          return DataCell(
            Text(d[c.dataAttribute]?.toString() ?? 'N/A'),
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
