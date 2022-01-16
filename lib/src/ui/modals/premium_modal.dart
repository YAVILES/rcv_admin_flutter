import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/models/coverage_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/providers/premium_provider.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';

class PremiumModal extends StatefulWidget {
  final Premium? premium;
  final List<Coverage>? coverage;

  const PremiumModal({Key? key, this.premium, this.coverage}) : super(key: key);

  @override
  State<PremiumModal> createState() => _PremiumModalState();
}

class _PremiumModalState extends State<PremiumModal> {
  late Premium _premium;
  @override
  void initState() {
    super.initState();
    _premium = widget.premium ?? Premium();
  }

  @override
  Widget build(BuildContext context) {
    final premiumProvider = Provider.of<PremiumProvider>(context);
    return Container(
      height: 500,
      decoration: buildBoxDecoration(context),
      child: CenteredView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomButtonPrimary(
                onPressed: () async {
                  /*  try {
                    if (_premium.id == null) {
                      await premiumProvider.newPremium(_premium, null);
                      NotificationService.showSnackbarSuccess(
                          '${_premium.title} creado');
                    } else {
                      await premiumProvider.editPremium(
                          _premium.id!, _premium, null);
                      NotificationService.showSnackbarSuccess(
                        '${_premium.title} actualizado',
                      );
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    Navigator.of(context).pop();
                    NotificationService.showSnackbarSuccess(
                      'No se pudo guardar el premium',
                    );
                  } */
                },
                title: 'Guardar',
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Theme.of(context).primaryColor,
      boxShadow: const [
        BoxShadow(color: Colors.black26),
      ],
    );
  }
}
