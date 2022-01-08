import 'dart:convert';

// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

class User {
  String? id;
  String? username;
  String? email;
  String? emailAlternative;
  String? name;
  String? lastName;
  String? fullName;
  String? direction;
  String? telephone;
  String? phone;
  String? point;
  // List<dynamic>? roles;
  // List<dynamic>? rolesDisplay;
  String? photo;
  String? password;
  bool? isActive;
  bool? isStaff;
  bool? isSuperuser;
  DateTime? created;
  DateTime? updated;

  User({
    this.id,
    this.username,
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
    this.isSuperuser = false,
    this.created,
    this.updated,
    this.isActive = true,
    this.photo,
    this.password,
  });

  Map<String, dynamic> toMap({bool? excludePhoto = false}) {
    return {
      'id': id,
      'username': username,
      'email': email,
      'email_alternative': emailAlternative,
      'name': name,
      'last_name': lastName,
      'full_name': fullName,
      'direction': direction,
      'telephone': telephone,
      'phone': phone,
      'point': point,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'created': created?.millisecondsSinceEpoch,
      'updated': updated?.millisecondsSinceEpoch,
      'is_active': isActive,
      if (excludePhoto != true) 'photo': photo,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      emailAlternative: map['email_alternative'],
      name: map['name'],
      lastName: map['last_name'],
      fullName: map['full_name'],
      direction: map['direction'],
      telephone: map['telephone'],
      phone: map['phone'],
      point: map['point'],
      isStaff: map['is_staff'],
      isSuperuser: map['is_superuser'],
      created: map['created'] != null ? DateTime.parse(map['created']) : null,
      updated: map['updated'] != null ? DateTime.parse(map['updated']) : null,
      isActive: map['is_active'],
      photo: map['photo'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
