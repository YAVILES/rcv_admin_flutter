import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/role_model.dart';

// To parse this JSON data, do
//
//     final client = clientFromMap(jsonString);

class Client {
  String? id;
  String? identificationNumber;
  String? clientname;
  String? email;
  String? emailAlternative;
  String? name;
  String? lastName;
  String? fullName;
  String? direction;
  String? telephone;
  String? phone;
  String? point;
  List<int>? roles = [];
  List<Role>? rolesDisplay = [];
  String? photo;
  String? password;
  bool? isActive;
  DateTime? created;
  DateTime? updated;

  Client({
    this.id,
    this.identificationNumber,
    this.clientname,
    this.email,
    this.emailAlternative,
    this.name,
    this.lastName,
    this.fullName,
    this.direction,
    this.telephone,
    this.phone,
    this.point,
    this.created,
    this.updated,
    this.isActive = true,
    this.photo,
    this.password,
    this.roles,
    this.rolesDisplay,
  });

  Map<String, dynamic> toMap({bool? excludePhoto = false}) {
    return {
      'id': id,
      'identification_number': identificationNumber,
      'clientname': clientname,
      'email': email,
      'email_alternative': emailAlternative,
      'name': name,
      'last_name': lastName,
      'full_name': fullName,
      'direction': direction,
      'telephone': telephone,
      'phone': phone,
      'point': point,
      'roles': roles,
      'roles_display': rolesDisplay?.map((x) => x.toMap()).toList(),
      'created': created?.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
      'is_active': isActive,
      if (excludePhoto != true) 'photo': photo,
      'password': password,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      identificationNumber: map['identification_number'],
      clientname: map['clientname'],
      email: map['email'],
      emailAlternative: map['email_alternative'],
      name: map['name'],
      lastName: map['last_name'],
      fullName: map['full_name'],
      direction: map['direction'],
      telephone: map['telephone'],
      phone: map['phone'],
      point: map['point'],
      roles: map["roles"] == null ? [] : List<int>.from(map["roles"]),
      rolesDisplay: map['roles_display'] != null
          ? List<Role>.from(map['roles_display']?.map((x) => Role.fromMap(x)))
          : null,
      photo: map['photo'],
      password: map['password'],
      isActive: map["is_active"] ?? true,
      created: map['created'] != null ? DateTime.parse(map["created"]) : null,
      updated: map['updated'] != null ? DateTime.parse(map["updated"]) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source));
}
