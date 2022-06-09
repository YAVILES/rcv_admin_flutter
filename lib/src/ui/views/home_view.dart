import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/services/home_service.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
// This widget is the home page of your application. It is stateful, meaning
  @override
  Widget build(BuildContext context) {
    return /* ScreenTypeLayout(
      mobile: const Center(
        child: Text("HomeContentMobile"),
      ),
      desktop: */
        SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: FutureBuilder(
            future: HomeService.getData(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        color: Theme.of(context).primaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        color: Theme.of(context).primaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        color: Theme.of(context).primaryColor,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        color: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
