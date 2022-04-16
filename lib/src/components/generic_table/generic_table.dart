import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table_datasource.dart';

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
  double? dataRowHeight;
  bool? paginated = true;

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
    this.dataRowHeight,
    this.paginated = true,
  }) : super(key: key);

  @override
  State<GenericTable> createState() => _GenericTableState();
}

class _GenericTableState extends State<GenericTable> {
  bool sortAscending = false;
  int sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    String valueSearch = widget.searchInitialValue ?? '';
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
              sort((column) => column[c.dataAttribute], colIndex);
            }
          },
        ),
      )
    ];

    return SizedBox(
      width: double.maxFinite,
      child: widget.paginated == true
          ? PaginatedDataTable(
              onSelectAll: (value) {
                setState(() {
                  if (value == true) {
                    widget.itemsIdsSelected =
                        widget.data.map((e) => e['id'].toString()).toList();
                  } else {
                    widget.itemsIdsSelected = [];
                  }
                });
                widget.onSelectAll != null
                    ? widget.onSelectAll!(value ?? false)
                    : {};
              },
              dataRowHeight: widget.dataRowHeight ?? kMinInteractiveDimension,
              sortAscending: sortAscending,
              showCheckboxColumn: widget.showCheckboxColumn ?? false,
              header: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.title != null && widget.title!.isNotEmpty)
                    Text(widget.title!),
                  if (widget.withSearchEngine == true) ...[
                    ListTile(
                      title: TextFormField(
                          initialValue: valueSearch.isEmpty
                              ? widget.searchInitialValue ?? ''
                              : valueSearch,
                          onChanged: (value) => valueSearch = value,
                          textAlignVertical: TextAlignVertical.center,
                          onFieldSubmitted: (value) => widget.onSearch != null
                              ? widget.onSearch!(valueSearch)
                              : {}),
                      trailing: IconButton(
                        splashRadius: 15,
                        onPressed: () => widget.onSearch != null
                            ? widget.onSearch!(valueSearch)
                            : {},
                        icon: const Icon(Icons.refresh_outlined),
                      ),
                    ),
                  ]
                ],
              ),
              sortColumnIndex: sortColumnIndex,
              columns: dataColumns,
              source: GenericTableDTS(
                data: widget.data,
                context: context,
                columns: widget.columns,
                onSelectChanged: (DataSelectChange dataChange) {
                  if (widget.showCheckboxColumn == true) {
                    if (dataChange.select == true) {
                      setState(() =>
                          widget.itemsIdsSelected.add(dataChange.item['id']));
                    } else {
                      setState(() => widget.itemsIdsSelected
                          .remove(dataChange.item['id']));
                    }
                    if (widget.onSelectChanged != null) {
                      widget.onSelectChanged!(dataChange);
                    }
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
                  IconButton(
                    color: Colors.redAccent[700],
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => widget.onDeleteSelectedItems != null
                        ? widget.onDeleteSelectedItems!(
                            widget.data
                                .where((e) => widget.itemsIdsSelected
                                    .contains(e['id'].toString()))
                                .toList(),
                          )
                        : {},
                  ),
              ],
            )
          : DataTable(
              onSelectAll: (value) {
                setState(() {
                  if (value == true) {
                    widget.itemsIdsSelected =
                        widget.data.map((e) => e['id'].toString()).toList();
                  } else {
                    widget.itemsIdsSelected = [];
                  }
                });
                widget.onSelectAll != null
                    ? widget.onSelectAll!(value ?? false)
                    : {};
              },
              dataRowHeight: widget.dataRowHeight ?? kMinInteractiveDimension,
              sortAscending: sortAscending,
              showCheckboxColumn: widget.showCheckboxColumn ?? false,
              sortColumnIndex: sortColumnIndex,
              columns: dataColumns,
              rows: List<DataRow>.generate(
                widget.data.length,
                (int index) => DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    // All rows will have the same selected color.
                    if (states.contains(MaterialState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }
                    // Even rows will have a grey color.
                    if (index.isEven) {
                      return Colors.grey.withOpacity(0.3);
                    }
                    return null; // Use default value for other states and odd rows.
                  }),
                  cells: <DataCell>[
                    ...widget.columns.map((c) {
                      if (c.widget != null) {
                        return DataCell(c.widget!(widget.data[index]));
                      }
                      if (c.type == TypeColumn.dateTime) {
                        var formatterDate = DateFormat('yyyy-MM-dd');
                        var formatterHour = DateFormat('h:mm:ss a');
                        return DataCell(
                          widget.data[index][c.dataAttribute] != null
                              ? Column(
                                  children: [
                                    Text(
                                      formatterDate.format(
                                        DateTime.parse(widget.data[index]
                                            [c.dataAttribute]),
                                      ),
                                    ),
                                    Text(
                                      formatterHour.format(
                                        DateTime.parse(widget.data[index]
                                            [c.dataAttribute]),
                                      ),
                                    ),
                                  ],
                                )
                              : const Text('N/A'),
                        );
                      }
                      return DataCell(
                        Text(widget.data[index][c.dataAttribute]?.toString() ??
                            'N/A'),
                      );
                    })
                  ],
                  /*      selected: selected[index],
            onSelectChanged: (bool? value) {
              setState(() {
                selected[index] = value!;
              });
            }, */
                ),
              ),
            ),
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
