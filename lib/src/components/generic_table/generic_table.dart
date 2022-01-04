import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/generic_table_datasource.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class GenericTable extends StatefulWidget {
  List<Map<String, dynamic>> data;
  List<DTColumn> columns;
  List<CustomButton>? actions;
  String? title;
  String? subtitle;
  String? newTitle;
  /* Campos a filtrar */
  List<DTFilterField>? filterFields = [];
  Function? onNewPressed;

  GenericTable({
    Key? key,
    required this.data,
    required this.columns,
    this.actions,
    this.title,
    this.subtitle,
    this.newTitle,
    this.filterFields,
    this.onNewPressed,
  }) : super(key: key);

  @override
  State<GenericTable> createState() => _GenericTableState();
}

class _GenericTableState extends State<GenericTable> {
  bool sortAscending = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dataColumns = [
      ...widget.columns.map(
        (c) => DataColumn(
          label: Text(c.header ?? c.attribute ?? c.dataAttribute),
          onSort: (colIndex, _) {
            if (c.onSort == true) {
              sort((banner) => banner[c.dataAttribute], colIndex);
            }
          },
        ),
      )
    ];
    return PaginatedDataTable(
      sortAscending: sortAscending,
      // sortColumnIndex: sortColumnIndex,
      columns: dataColumns,
      source: GenericTableDTS(
          data: widget.data, context: context, columns: widget.columns),
      header: HeaderView(title: widget.title, subtitle: widget.subtitle),
      rowsPerPage: (widget.data.length < 10 && widget.data.isNotEmpty)
          ? widget.data.length
          : 10,
      /*     onRowsPerPageChanged: (value) =>
              setState(() => rowsPerPage = value ?? _rowsPerPage), */
      onPageChanged: (value) => {},
      actions: [
        ElevatedButton(
          child: Text(widget.newTitle ?? "Nuevo"),
          onPressed: () => widget.onNewPressed!(),
        ),
      ],
    );
  }

  void sort<T>(Comparable<T> Function(Map<String, dynamic> info) getField,
      int indexSort) {
    setState(
      () {
        sortAscending = !sortAscending;
        sortColumnIndex = indexSort;
        widget.data.sort((a, b) {
          final aValue = getField(a);
          final bValue = getField(b);
          return sortAscending
              ? Comparable.compare(aValue, bValue)
              : Comparable.compare(bValue, aValue);
        });
      },
    );
  }
}
