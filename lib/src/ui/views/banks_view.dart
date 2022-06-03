import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/bank_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:responsive_table/responsive_table.dart';

class BanksView extends StatefulWidget {
  const BanksView({Key? key}) : super(key: key);

  @override
  State<BanksView> createState() => _BanksViewState();
}

class _BanksViewState extends State<BanksView> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50];
  int _total = 100;
  String? _next;
  String? _previos;
  int? _currentPerPage = 50;
  List<bool>? _expanded;
  int _currentPage = 1;
  bool _isSearch = false;
  String searchCurrent = "";
  List<Map<String, dynamic>> _source = [];
  bool _isLoading = true;

  _initializeData() async {
    refreshData();
  }

  refreshData() async {
    setState(() => _isLoading = true);
    ResponseData data = await BankService.getBanks(
      {"limit": _currentPerPage, "search": searchCurrent},
    );
    _source = data.results;
    _next = data.next;
    _previos = data.previous;
    _total = _source.length;
    _expanded = List.generate(_total, (index) => false);
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(text: "Código", value: "code"),
      DatatableHeader(text: "Descripción", value: "description"),
      DatatableHeader(
          text: "Modenas", value: "coins_display", textAlign: TextAlign.left),
      DatatableHeader(text: "Métodos de Pago", value: "methods_display"),
      DatatableHeader(text: "Estatus", value: "status_display"),
      DatatableHeader(
        text: "Acciones",
        value: "id",
        sourceBuilder: (value, row) {
          return _ActionsTable(item: row);
        },
      )
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        child: CenteredView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              HeaderView(
                title: "Administración Web",
                subtitle: "Banners",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, bannerRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(0),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: ResponsiveDatatable(
                    reponseScreenSizes: const [ScreenSize.xs],
                    actions: [
                      if (_isSearch)
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar',
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(
                                    () {
                                      _isSearch = false;
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
                              refreshData();
                            },
                            onChanged: (value) {
                              setState(() {
                                searchCurrent = value;
                              });
                            },
                          ),
                        ),
                      if (!_isSearch)
                        IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _isSearch = true;
                              });
                            })
                    ],
                    headers: _headers,
                    source: _source,
                    selecteds: const [],
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
                    expanded: _expanded,
                    isLoading: _isLoading,
                    footers: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text("Filas por página:"),
                      ),
                      if (_perPages.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<int>(
                            value: _currentPerPage,
                            items: _perPages
                                .map((e) => DropdownMenuItem<int>(
                                      child: Text("$e"),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                _currentPerPage = value;
                                _currentPage = 1;
                                refreshData();
                                // _resetData();
                              });
                            },
                            isExpanded: false,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child:
                            Text("$_currentPage - $_currentPerPage of $_total"),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: _currentPage == 1
                            ? null
                            : () {
                                var _nextSet = _currentPage - _currentPerPage!;
                                setState(() {
                                  _currentPage = _nextSet > 1 ? _nextSet : 1;
                                  // _resetData(start: _currentPage - 1);
                                });
                              },
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _currentPage + _currentPerPage! - 1 > _total
                            ? null
                            : () {
                                var _nextSet = _currentPage + _currentPerPage!;

                                setState(() {
                                  _currentPage = _nextSet < _total
                                      ? _nextSet
                                      : _total - _currentPerPage!;
                                  // _resetData(start: _nextSet - 1);
                                });
                              },
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsTable extends StatelessWidget {
  Map<String?, dynamic> item;
  _ActionsTable({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            NavigationService.navigateTo(
              context,
              bankDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
