import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/models/role_model.dart';

// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

class User {
  String? id;
  String? username;
  String? email;
  String? documentType;
  String? identificationNumber;
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
  String? branchOffice;
  BranchOffice? branchOfficeDisplay;
  bool? isActive;
  bool? isStaff;
  bool? isAdviser;
  bool? isSuperuser;
  DateTime? created;
  DateTime? updated;

  User({
    this.id,
    this.username,
    this.documentType,
    this.identificationNumber,
    this.email,
    this.emailAlternative,
    this.name,
    this.lastName,
    this.fullName,
    this.direction,
    this.telephone,
    this.phone,
    this.point,
    this.isStaff = true,
    this.isAdviser = false,
    this.isSuperuser = false,
    this.created,
    this.updated,
    this.isActive = true,
    this.photo,
    this.password,
    this.roles,
    this.rolesDisplay,
    this.branchOffice,
    this.branchOfficeDisplay,
  });

  Map<String, dynamic> toMap({bool? excludePhoto = false}) {
    return {
      'id': id,
      'username': username,
      'document_type': documentType,
      'identification_number': identificationNumber,
      'email': email,
      'email_alternative': emailAlternative ?? '',
      'name': name,
      'last_name': lastName,
      'full_name': fullName,
      'direction': direction,
      'telephone': telephone,
      'phone': phone,
      'point': point,
      'is_staff': isStaff,
      'is_adviser': isAdviser,
      'is_superuser': isSuperuser,
      'roles': roles,
      'roles_display': rolesDisplay?.map((x) => x.toMap()).toList(),
      'branch_office': branchOffice,
      'branch_office_display': branchOfficeDisplay?.toMap(),
      'created': created?.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
      'is_active': isActive,
      if (excludePhoto != true) 'photo': photo,
      'password': password,
    };
  }

  Map<String, dynamic> toMapSave({bool? excludePhoto = false}) {
    return {
      'id': id,
      'username': username,
      'document_type': documentType,
      'identification_number': identificationNumber,
      'email': email,
      'email_alternative': emailAlternative ?? '',
      'name': name,
      'last_name': lastName,
      'full_name': fullName,
      'direction': direction,
      'telephone': telephone,
      'phone': phone,
      'point': point,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'roles': roles,
      'branch_office': branchOffice,
      'is_active': isActive,
      if (excludePhoto != true) 'photo': photo,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      documentType: map['document_type'],
      identificationNumber: map['identification_number'],
      email: map['email'],
      emailAlternative: map['email_alternative'] ?? '',
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
      branchOffice: map["branch_office"],
      branchOfficeDisplay: map['branch_office_display'] != null
          ? BranchOffice.fromMap(map['branch_office_display'])
          : null,
      photo: map['photo'],
      password: map['password'],
      isActive: map["is_active"] ?? true,
      isStaff: map['is_staff'],
      isAdviser: map['is_adviser'],
      isSuperuser: map['is_superuser'],
      created: map['created'] != null ? DateTime.parse(map["created"]) : null,
      updated: map['updated'] != null ? DateTime.parse(map["updated"]) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
