import 'package:flutter/material.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table_datasource.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';

class GenericTable extends StatefulWidget {
  List<String> itemsIdsSelected = [];
  List<Map<String, dynamic>> data = [];
  List<DTColumn> columns;

  String? title;
  String? subtitle;
  String? newTitle;
  /* Campos a filtrar */
  List<DTFilterField>? filterFields = [];
  Function? onNewPressed;
  String? labelforNoData;
  bool? withSearchEngine;
  Function(String?)? onSearch;
  String? searchInitialValue;
  Function(bool)? onSelectAll;
  bool? showCheckboxColumn;
  void Function(DataSelectChange dataChange)? onSelectChanged;
  void Function(List<Map<String, dynamic>>)? onDeleteSelectedItems;

  GenericTable({
    Key? key,
    required this.data,
    required this.columns,
    this.title,
    this.subtitle,
    this.newTitle,
    this.filterFields,
    this.onNewPressed,
    this.labelforNoData,
    this.withSearchEngine = true,
    this.onSearch,
    this.searchInitialValue,
    this.onSelectAll,
    this.showCheckboxColumn,
    this.onSelectChanged,
    this.onDeleteSelectedItems,
  }) : super(key: key);

  @override
  State<GenericTable> createState() => _GenericTableState();
}

class _GenericTableState extends State<GenericTable> {
  bool sortAscending = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    String valueSearch = '';
/*     if (widget.data.isEmpty) {
      return Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            widget.labelforNoData ?? "Sin información",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else { */
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
      onSelectAll: (value) {
        setState(() {
          if (value == true) {
            widget.itemsIdsSelected =
                widget.data.map((e) => e['id'].toString()).toList();
          } else {
            widget.itemsIdsSelected = [];
          }
        });
        widget.onSelectAll != null ? widget.onSelectAll!(value ?? false) : {};
      },
      sortAscending: sortAscending,
      showCheckboxColumn: widget.showCheckboxColumn ?? false,
      header: Row(),
      sortColumnIndex: sortColumnIndex,
      columns: dataColumns,
      source: GenericTableDTS(
        data: widget.data,
        context: context,
        columns: widget.columns,
        onSelectChanged: (DataSelectChange dataChange) {
          if (dataChange.select == true) {
            setState(() => widget.itemsIdsSelected.add(dataChange.item['id']));
          }
          if (widget.onSelectChanged != null) {
            widget.onSelectChanged!(dataChange);
          }
        },
        itemsIdsSelected: widget.itemsIdsSelected,
      ),
      rowsPerPage: (widget.data.isNotEmpty)
          ? (widget.data.length < 50)
              ? widget.data.length
              : 50
          : 1,
      /*     onRowsPerPageChanged: (value) =>
                  setState(() => rowsPerPage = value ?? _rowsPerPage), */
      onPageChanged: (value) => {},
      actions: [
        if (widget.itemsIdsSelected.isNotEmpty)
          CustomButtonPrimary(
            title: 'Eliminar items seleccionados',
            color: Colors.red,
            onPressed: () => widget.onDeleteSelectedItems != null
                ? widget.onDeleteSelectedItems!(
                    widget.data
                        .where((e) => widget.itemsIdsSelected
                            .contains(e['id'].toString()))
                        .toList(),
                  )
                : {},
          ),
        if (widget.withSearchEngine == true) ...[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextFormField(
              initialValue: valueSearch.isEmpty
                  ? widget.searchInitialValue ?? ''
                  : valueSearch,
              onChanged: (value) => valueSearch = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () =>
                  widget.onSearch != null ? widget.onSearch!(valueSearch) : {},
              icon: const Icon(Icons.refresh_outlined),
            ),
          ),
        ],
      ],
    );
    // }
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
