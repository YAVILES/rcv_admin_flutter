import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/providers/bank_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BankView extends StatefulWidget {
  Bank? bank;
  String? uid;

  BankView({
    Key? key,
    this.bank,
    this.uid,
  }) : super(key: key);

  @override
  State<BankView> createState() => _BankViewState();
}

class _BankViewState extends State<BankView> {
  @override
  Widget build(BuildContext context) {
    if (widget.bank != null) {
      return _BankViewBody(bank: widget.bank!);
    } else {
      return FutureBuilder(
        future: Provider.of<BankProvider>(context, listen: false)
            .getBank(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _BankViewBody(bank: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _BankViewBody extends StatefulWidget {
  Bank bank;

  _BankViewBody({
    Key? key,
    required this.bank,
  }) : super(key: key);

  @override
  __BankViewBodyState createState() => __BankViewBodyState();
}

class __BankViewBodyState extends State<_BankViewBody> {
  @override
  void initState() {
    Provider.of<BankProvider>(context, listen: false).formBankKey =
        GlobalKey<FormState>();
    Provider.of<BankProvider>(context, listen: false).bank = widget.bank;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BankProvider bankProvider = Provider.of<BankProvider>(context);
    Bank _bank = bankProvider.bank!;
    final bool create = widget.bank.id == null;
    GroupController controllerGroup = GroupController();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Pagos',
              subtitle: 'Banco ${widget.bank.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: bankProvider.formBankKey,
                  child: Wrap(
                    children: [
                      TextFormField(
                        readOnly: !create,
                        initialValue: _bank.code ?? '',
                        onChanged: (value) => _bank.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveBank(create, bankProvider, _bank),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.description ?? '',
                        onChanged: (value) => _bank.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveBank(create, bankProvider, _bank),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.email ?? '',
                        onChanged: (value) => _bank.email = value,
                        onFieldSubmitted: (value) =>
                            _saveBank(create, bankProvider, _bank),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el email.',
                          labelText: 'Email',
                        ),
                      ),
                      FutureBuilder(
                        future: PaymentService.getMethods(),
                        builder:
                            (context, AsyncSnapshot<List<Option>?> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? SimpleGroupedCheckbox<int>(
                                  groupTitle: "Metodos de pago",
                                  controller: controllerGroup,
                                  itemsTitle: snapshot.data!
                                      .map((e) => e.description!)
                                      .toList(),
                                  values: snapshot.data!
                                      .map((e) => int.parse(e.value!))
                                      .toList(),
                                  isExpandableTitle: true,
                                  groupStyle: GroupStyle(
                                    activeColor: Colors.red,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13),
                                  ),
                                  checkFirstElement: false,
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      FutureBuilder(
                        future: PaymentService.getCoins(),
                        builder:
                            (context, AsyncSnapshot<List<Option>?> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? SimpleGroupedCheckbox<String>(
                                  groupTitle: "Monedas",
                                  controller: controllerGroup,
                                  itemsTitle: snapshot.data!
                                      .map((e) => e.description!)
                                      .toList(),
                                  values: snapshot.data!
                                      .map((e) => e.value!)
                                      .toList(),
                                  isExpandableTitle: true,
                                  groupStyle: GroupStyle(
                                    activeColor: Colors.red,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13),
                                  ),
                                  checkFirstElement: false,
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _bank.status == 1,
                          onChanged: (value) => _bank.status = value ? 1 : 0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveBank(create, bankProvider, _bank),
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

  Future<bool?> _saveBank(
    bool create,
    BankProvider bankProvider,
    Bank _bank,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await bankProvider.newBank(_bank) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_bank.description} creado');
          }
        } else {
          saved = await bankProvider.editBank(_bank.id!, _bank) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_bank.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el bank',
        );
      }
    }
  }
}
