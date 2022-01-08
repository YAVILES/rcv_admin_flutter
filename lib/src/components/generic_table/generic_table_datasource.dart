import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:intl/intl.dart';

class GenericTableDTS extends DataTableSource {
  List<String>? itemsIdsSelected = [];
  final List<dynamic> data;
  final List<DTColumn> columns;
  final BuildContext context;
  void Function(DataSelectChange dataChange) onSelectChanged;

  GenericTableDTS({
    required this.data,
    required this.columns,
    required this.context,
    required this.onSelectChanged,
    this.itemsIdsSelected,
  }) {
    itemsIdsSelected = itemsIdsSelected ?? [];
  }

  @override
  DataRow? getRow(int index) {
    final d = data[index];
    return DataRow.byIndex(
      index: index,
      selected: itemsIdsSelected!.contains(d['id'].toString()),
      onSelectChanged: (select) => onSelectChanged(
        DataSelectChange(index: index, item: d, select: select),
      ),
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
