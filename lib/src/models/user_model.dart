// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

class User {
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
    this.isStaff = false,
    this.isSuperuser = false,
    // this.roles,
    // this.rolesDisplay,
    this.info,
    this.created,
    this.updated,
    this.isActive,
    this.photo,
    this.password,
  });

  String? id;
  String? username;
  String? email;
  dynamic emailAlternative;
  String? name;
  String? lastName;
  String? fullName;
  dynamic direction;
  dynamic telephone;
  String? phone;
  dynamic point;
  bool? isStaff;
  bool? isSuperuser;
  // List<dynamic>? roles;
  // List<dynamic>? rolesDisplay;
  Info? info;
  DateTime? created;
  DateTime? updated;
  bool? isActive;
  String? photo;
  String? password;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        emailAlternative: json["email_alternative"],
        name: json["name"],
        lastName: json["last_name"],
        fullName: json["full_name"],
        direction: json["direction"],
        telephone: json["telephone"],
        phone: json["phone"],
        point: json["point"],
        isSuperuser: json["is_superuser"],
        isStaff: json["is_staff"],
        // roles: List<dynamic>.from(json["roles"].map((x) => x)),
        // rolesDisplay: List<dynamic>.from(json["roles_display"].map((x) => x)),
        info: Info.fromMap(json["info"]),
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        isActive: json["is_active"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap({bool excludePhoto = false}) => {
        "id": id,
        "username": username,
        "email": email,
        "email_alternative": emailAlternative,
        "name": name,
        "last_name": lastName,
        // "full_name": fullName ?? '',
        "direction": direction,
        "telephone": telephone,
        "phone": phone,
        // "point": point,
        "is_superuser": isSuperuser,
        "is_staff": isStaff,
        // "roles": List<dynamic>.from(roles!.map((x) => x)),
        // "roles_display": List<dynamic>.from(rolesDisplay!.map((x) => x)),
        // "info": info!.toMap(),
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "is_active": isActive,
        if (!excludePhoto) "photo": photo,
      };
}

class Info {
  Info();

  factory Info.fromJson(String str) => Info.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Info.fromMap(Map<String, dynamic> json) => Info();

  Map<String, dynamic> toMap() => {};
}
