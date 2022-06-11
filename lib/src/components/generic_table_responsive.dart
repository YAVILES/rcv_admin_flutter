import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:responsive_table/responsive_table.dart';

class GenericTableResponsive extends StatefulWidget {
  GenericTableResponsive({
    Key? key,
    required this.headers,
    required this.onSource,
    this.onImport,
    this.onExport,
    this.filenameExport,
    this.params,
    this.selecteds,
    this.onSelect,
    this.showSelect,
  }) : super(key: key);

  Future<ResponseData?> Function(Map<String, dynamic> params, String? url)
      onSource;
  Future Function(Map<String, dynamic> params)? onImport;
  Future<Uint8List?> Function(Map<String, dynamic> params)? onExport;
  String? filenameExport;
  List<DatatableHeader> headers;
  List<Map<String, dynamic>> source = [];
  Map<String, dynamic>? params;
  List<Map<String, dynamic>>? selecteds;
  dynamic Function(List<Map<String, dynamic>>)? onSelect;
  bool? showSelect;

  @override
  State<GenericTableResponsive> createState() => _GenericTableResponsiveState();
}

class _GenericTableResponsiveState extends State<GenericTableResponsive> {
  bool isSearch = false;

  List<bool> expanded = [];

  bool isLoading = false;

  List<int> perPages = [10, 20, 50];
  int total = 100;
  String? next;
  String? previos;
  int? currentPerPage = 50;
  int? currentPerPageFinal = 50;

  int currentPage = 1;
  String? searchCurrent;

  refreshData({String? url}) async {
    setState(() => isLoading = true);

    final data = await widget.onSource(widget.params ?? {}, url);
    setState(() {
      widget.source = data?.results ?? [];
      next = data?.next;
      previos = data?.previous;
      total = data?.count ?? 0; // widget.source.length;
      expanded = List.generate(total, (index) => false);
    });

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    widget.params ??= {};
    widget.selecteds ??= [];
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(0),
      child: Card(
        elevation: 1,
        shadowColor: Colors.black,
        clipBehavior: Clip.none,
        child: ResponsiveDatatable(
          showSelect: widget.showSelect ?? false,
          reponseScreenSizes: const [ScreenSize.sm],
          actions: [
            if (isSearch)
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(
                          () {
                            widget.params?.remove("search");
                            isSearch = false;
                            refreshData();
                          },
                        );
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        refreshData();
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    searchCurrent = value;
                    widget.params?["search"] = value;
                    refreshData();
                  },
                  onChanged: (value) {
                    searchCurrent = value;
                    widget.params?["search"] = value;
                  },
                ),
              ),
            if (!isSearch)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          isSearch = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        refreshData();
                      },
                    ),
                    if (widget.onExport != null)
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          if (!kIsWeb) {
                            if (Platform.isIOS ||
                                Platform.isAndroid ||
                                Platform.isMacOS) {
                              bool status = await Permission.storage.isGranted;

                              if (!status) await Permission.storage.request();
                            }
                          }
                          Uint8List? data =
                              await widget.onExport!(widget.params ?? {});
                          if (data != null) {
                            MimeType type = MimeType.MICROSOFTEXCEL;
                            String path = await FileSaver.instance.saveFile(
                                widget.filenameExport ?? "", data, "xlsx",
                                mimeType: type);
                            if (kDebugMode) {
                              print(path);
                            }
                          } else {
                            NotificationService.showSnackbarError(
                                'No se pudo descargar el excel');
                          }
                        },
                      ),
                    if (widget.onImport != null)
                      IconButton(
                        icon: const Icon(
                          Icons.upload,
                        ),
                        onPressed: () async {
                          await widget.onImport!(widget.params ?? {});
                        },
                      ),
                  ],
                ),
              )
          ],
          headers: widget.headers,
          source: widget.source,
          selecteds: widget.selecteds ?? [],
          onSelect: (select, row) {
            setState(() {
              if (select == true) {
                widget.selecteds!.add(row);
              } else {
                widget.selecteds!.remove(row);
              }
            });

            if (widget.onSelect != null) {
              widget.onSelect!(widget.selecteds!);
            }
          },
          onSelectAll: (selectAll) {
            setState(() {
              if (selectAll == true) {
                widget.selecteds = widget.source;
              } else {
                widget.selecteds = [];
              }
              if (widget.onSelect != null) {
                widget.onSelect!(widget.selecteds!);
              }
            });
          },
          autoHeight: true,
          onChangedRow: (value, header) {
            /// print(value);
            /// print(header);
          },
          onSubmittedRow: (value, header) {
            /// print(value);
            /// print(header);
          },
          onTabRow: (data) {
            //   print(data);
          },
          expanded: expanded,
          isLoading: isLoading,
          footers: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text("Filas por página:"),
            ),
            if (perPages.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton<int>(
                  value: currentPerPage,
                  items: perPages
                      .map((e) => DropdownMenuItem<int>(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (dynamic value) {
                    setState(() {
                      currentPerPage = value;
                      currentPerPageFinal = value;
                      currentPage = 1;
                      widget.params?["limit"] = value;
                      refreshData();
                      // _resetData();
                    });
                  },
                  isExpanded: false,
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("$currentPage - $currentPerPageFinal de $total"),
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
              onPressed: previos == null
                  ? null
                  : () {
                      var nextSet = currentPage - currentPerPage!;
                      setState(() {
                        currentPage = nextSet > 1 ? nextSet : 1;
                        currentPerPageFinal = nextSet > 1
                            ? (currentPerPageFinal! - currentPerPage!)
                            : currentPerPage;
                        refreshData(url: previos);
                        // _resetData(start: _currentPage - 1);
                      });
                    },
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: next == null
                  ? null
                  : () {
                      var nextSet = currentPage + currentPerPage!;

                      setState(() {
                        currentPage =
                            nextSet < total ? nextSet : total - currentPerPage!;
                        currentPerPageFinal = nextSet < total
                            ? (currentPerPageFinal! + currentPerPage!)
                            : total - currentPerPageFinal!;
                        refreshData(url: next);
                        // _resetData(start: _nextSet - 1);
                      });
                    },
              padding: const EdgeInsets.symmetric(horizontal: 15),
            )
          ],
        ),
      ),
    );
  }
}
