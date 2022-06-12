import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/services/home_service.dart';
import 'package:rcv_admin_flutter/src/utils/exmaple_char.dart';
// import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
// import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
// This widget is the home page of your application. It is stateful, meaning
  @override
  Widget build(BuildContext context) {
    TextStyle styleTitles = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return /* ScreenTypeLayout(
      mobile: const Center(
        child: Text("HomeContentMobile"),
      ),
      desktop: */
        SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            FutureBuilder(
                future: HomeService.getData(),
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                  final data = snapshot.data;
                  return snapshot.connectionState == ConnectionState.done
                      ? Wrap(
                          alignment: WrapAlignment.spaceAround,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Card(
                              margin: const EdgeInsets.all(2.5),
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                width: 280,
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.location_city_outlined,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Sucursales",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${data?["number_branches"]}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(2.5),
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                width: 280,
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.supervised_user_circle_outlined,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Clientes",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${data?["number_clients"]}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(2.5),
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                width: 280,
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.pending_actions_outlined,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Cotizaciones \n Pendientes",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${data?["number_pending_policies"]}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(2.5),
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                width: 280,
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.car_rental_outlined,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Vehiculos \n Asegurados",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${data?["number_insured_vehicles"]}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(2.5),
                              child: Container(
                                padding: const EdgeInsets.all(2.5),
                                width: 280,
                                height: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.payments_outlined,
                                      size: 60,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Pagos \n Pendientes",
                                          style: TextStyle(fontSize: 24),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${data?["pending_payments"]}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const MyProgressIndicator();
                }),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 30),
              child: SizedBox(
                height: 330,
                child: FutureBuilder(
                    future: HomeService.getPolicyForBranchOffice(),
                    builder: (_,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.data != null && snapshot.data!.isNotEmpty
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  child: BarChart(
                                    BarChartData(
                                      barTouchData: BarTouchData(
                                        touchTooltipData: BarTouchTooltipData(
                                            tooltipBgColor: Colors.blueGrey,
                                            getTooltipItem: (group, groupIndex,
                                                rod, rodIndex) {
                                              return BarTooltipItem(
                                                snapshot.data!
                                                        .where((e) =>
                                                            e["number"] ==
                                                            group.x)
                                                        .first["description"] +
                                                    '\n',
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        'polizas: ${(rod.toY).toString()}',
                                                    style: const TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                        touchCallback: (FlTouchEvent event,
                                            barTouchResponse) {},
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        leftTitles: AxisTitles(
                                          axisNameSize: 30,
                                          axisNameWidget: Text(
                                            "Polizas",
                                            style: styleTitles,
                                          ),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          axisNameSize: 30,
                                          axisNameWidget: Text(
                                            "Sucursales",
                                            style: styleTitles,
                                          ),
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) =>
                                                Text(
                                              snapshot.data!
                                                  .where((e) =>
                                                      e["number"] == value)
                                                  .first["description"],
                                              style: styleTitles,
                                            ),
                                            reservedSize: 18,
                                          ),
                                        ),
                                      ),
                                      barGroups: snapshot.data
                                          ?.map(
                                            (e) => BarChartGroupData(
                                              x: e["number"],
                                              barRods: [
                                                BarChartRodData(
                                                  toY: e["quantity"],
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  width: 20,
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 0),
                                                ),
                                              ],
                                              // showingTooltipIndicators: showTooltips,
                                            ),
                                          )
                                          .toList(),
                                      gridData: FlGridData(
                                        show: true,
                                        drawVerticalLine: false,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const MyProgressIndicator();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
