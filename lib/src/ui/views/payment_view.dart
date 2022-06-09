import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/payment_model.dart';
import 'package:rcv_admin_flutter/src/providers/payment_provider.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class PaymentView extends StatefulWidget {
  Payment? payment;
  String? uid;

  PaymentView({
    Key? key,
    this.payment,
    this.uid,
  }) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  Widget build(BuildContext context) {
    if (widget.payment != null) {
      return _PaymentViewBody(payment: widget.payment!);
    } else {
      return FutureBuilder(
        future: Provider.of<PaymentProvider>(context, listen: false)
            .getPayment(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _PaymentViewBody(payment: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _PaymentViewBody extends StatefulWidget {
  Payment payment;

  _PaymentViewBody({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  __PaymentViewBodyState createState() => __PaymentViewBodyState();
}

class __PaymentViewBodyState extends State<_PaymentViewBody> {
  @override
  void initState() {
    Provider.of<PaymentProvider>(context, listen: false).formPaymentKey =
        GlobalKey<FormState>();
    Provider.of<PaymentProvider>(context, listen: false).payment =
        widget.payment;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context);
    Payment _payment = paymentProvider.payment!;

    final bool create = widget.payment.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Pagos',
              subtitle: 'Pago ${widget.payment.number ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: paymentProvider.formPaymentKey,
                  child: Wrap(
                    children: [
                      if (!create)
                        TextFormField(
                          readOnly: true,
                          initialValue: _payment.number.toString(),
                          onFieldSubmitted: (value) {},
                          decoration: CustomInputs.buildInputDecoration(
                            // hintText: 'Ingrese la descripción.',
                            labelText: 'Número',
                          ),
                        ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _payment.status == 1,
                          onChanged: (value) =>
                              _payment.status = value == true ? 1 : 0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () {},
                          title: 'Guardar',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
