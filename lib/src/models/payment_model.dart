import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';

class Payment {
  String? id;
  String? archiveDisplay;
  String? statusDisplay;
  String? methodDisplay;
  User? userDisplay;
  Bank? bankDisplay;
  Policy? policyDisplay;
  String? amountDisplay;
  String? amountFullDisplay;
  String? totalFullBsDisplay;
  String? created;
  String? updated;
  int? number;
  double? amount;
  String? commentary;
  int? method;
  String? reference;
  String? coin;
  String? archive;
  double? changeFactor;
  int? status;
  String? bank;
  String? policy;
  String? user;

  Payment(
      {this.id,
      this.archiveDisplay,
      this.statusDisplay,
      this.methodDisplay,
      this.userDisplay,
      this.bankDisplay,
      this.policyDisplay,
      this.amountDisplay,
      this.amountFullDisplay,
      this.totalFullBsDisplay,
      this.created,
      this.updated,
      this.number,
      this.amount,
      this.commentary,
      this.method,
      this.reference,
      this.coin,
      this.archive,
      this.changeFactor,
      this.status,
      this.bank,
      this.policy,
      this.user});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    archiveDisplay = json['archive_display'];
    statusDisplay = json['status_display'];
    methodDisplay = json['method_display'];
    userDisplay = json['user_display'] != null
        ? User.fromJson(json['user_display'])
        : null;
    bankDisplay = json['bank_display'] != null
        ? Bank.fromJson(json['bank_display'])
        : null;
    policyDisplay = json['policy_display'] != null
        ? Policy.fromJson(json['policy_display'])
        : null;
    amountDisplay = json['amount_display'];
    amountFullDisplay = json['amount_full_display'];
    totalFullBsDisplay = json['total_full_bs_display'];
    created = json['created'];
    updated = json['updated'];
    number = json['number'];
    amount = json['amount'] != null ? double.parse(json['amount']) : null;
    commentary = json['commentary'];
    method = json['method'];
    reference = json['reference'];
    coin = json['coin'];
    archive = json['archive'];
    changeFactor = json['change_factor'] != null
        ? double.parse(json['change_factor'])
        : null;
    status = json['status'];
    bank = json['bank'];
    policy = json['policy'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['archive_display'] = archiveDisplay;
    data['status_display'] = statusDisplay;
    data['method_display'] = methodDisplay;
    if (userDisplay != null) {
      data['user_display'] = userDisplay!.toJson();
    }
    if (bankDisplay != null) {
      data['bank_display'] = bankDisplay!.toJson();
    }
    if (policyDisplay != null) {
      data['policy_display'] = policyDisplay!.toJson();
    }
    data['amount_display'] = amountDisplay;
    data['amount_full_display'] = amountFullDisplay;
    data['total_full_bs_display'] = totalFullBsDisplay;
    data['created'] = created;
    data['updated'] = updated;
    data['number'] = number;
    data['amount'] = amount;
    data['commentary'] = commentary;
    data['method'] = method;
    data['reference'] = reference;
    data['coin'] = coin;
    data['archive'] = archive;
    data['change_factor'] = changeFactor;
    data['status'] = status;
    data['bank'] = bank;
    data['policy'] = policy;
    data['user'] = user;
    return data;
  }
}
