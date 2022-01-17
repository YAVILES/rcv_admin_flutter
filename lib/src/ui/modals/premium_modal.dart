import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/premium_provider.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/services/premium_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';

class PremiumModal extends StatefulWidget {
  final Plan plan;
  final Use use;

  const PremiumModal({
    Key? key,
    required this.plan,
    required this.use,
  }) : super(key: key);

  @override
  State<PremiumModal> createState() => _PremiumModalState();
}

class _PremiumModalState extends State<PremiumModal> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<PremiumProvider>(context, listen: false).premiums = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PremiumProvider premiumProvider =
        Provider.of<PremiumProvider>(context, listen: false);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          height: 600,
          decoration: buildBoxDecoration(context),
          child: Column(
            children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.plan.description.toString(),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Center(
                  child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  widget.use.description.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Coberturas: ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                child: FutureBuilder(
                    future: PlanService.getPlanPerUse(
                        widget.plan.id!, widget.use.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: Column(
                            children: [
                              ...widget.plan.coverage!.map((c) {
                                if (c.premium == null) {
                                  premiumProvider.premiums.add(Premium.fromMap({
                                    "coverage": c.id,
                                    "use": widget.use.id,
                                    "plan": widget.plan.id,
                                    "insured_amount": 0,
                                    "cost": 0,
                                  }));
                                } else {
                                  premiumProvider.premiums.add(c.premium!);
                                }
                                return Row(
                                  children: [
                                    Expanded(child: Text(c.description!)),
                                    const SizedBox(width: 15),
                                    TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      initialValue:
                                          c.premium?.insuredAmount.toString() ??
                                              '0',
                                      onChanged: (value) =>
                                          premiumProvider.defineinsuredAmount(
                                              c.id!, double.parse(value)),
                                      decoration:
                                          CustomInputs.buildInputDecoration(
                                        hintText: 'Ingrese el monto asegurado',
                                        labelText: 'Monto asegurado',
                                        constraints:
                                            const BoxConstraints(maxWidth: 120),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    TextFormField(
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      initialValue:
                                          c.premium?.insuredAmount.toString() ??
                                              '0',
                                      onChanged: (value) =>
                                          premiumProvider.defineCost(
                                              c.id!, double.parse(value)),
                                      decoration:
                                          CustomInputs.buildInputDecoration(
                                        hintText: 'Ingrese la prima',
                                        labelText: 'Prima',
                                        constraints:
                                            const BoxConstraints(maxWidth: 120),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        );
                      } else {
                        return const MyProgressIndicator();
                      }
                    }),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: CustomButtonPrimary(
                  onPressed: () async {
                    try {
                      PremiumService.saveMultiple(premiumProvider.premiums);
                      NotificationService.showSnackbarSuccess(
                          'Guardado con exito');

                      // NavigationService.backTo(context);
                    } catch (e) {
                      NotificationService.showSnackbarError(
                        'No fue posible guardar guardar',
                      );
                    }
                  },
                  title: 'Guardar',
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          top: 10,
          right: 10,
          child: Icon(Icons.close, color: Colors.black, size: 35),
        ),
      ],
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black26),
      ],
    );
  }
}
