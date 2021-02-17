import 'dart:convert';

List<Employees> employeesFromJson(String str) => List<Employees>.from(json.decode(str).map((x) => Employees.fromJson(x)));

String employeesToJson(List<Employees> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employees {
  Employees({
    this.adminId,
    this.name,
    this.username,
    this.tel,
    this.email,
    this.proFileUrl,
    this.active,
  });

  String adminId;
  String name;
  String username;
  String tel;
  String email;
  String proFileUrl;
  String active;

  factory Employees.fromJson(Map<String, dynamic> json) => Employees(
    adminId: json["admin_id"],
    name: json["name"],
    username: json["username"],
    tel: json["tel"],
    email: json["email"],
    proFileUrl: json["pro_file_url"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "admin_id": adminId,
    "name": name,
    "username": username,
    "tel": tel,
    "email": email,
    "pro_file_url": proFileUrl,
    "active": active,
  };
}
