import 'dart:convert';

List<GroupProduct> groupProductFromJson(String str) => List<GroupProduct>.from(json.decode(str).map((x) => GroupProduct.fromJson(x)));

String groupProductToJson(List<GroupProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupProduct {
  GroupProduct({
    this.fgId,
    this.name,
    this.status,
  });

  String fgId;
  String name;
  String status;

  factory GroupProduct.fromJson(Map<String, dynamic> json) => GroupProduct(
    fgId: json["fg_id"],
    name: json["name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "fg_id": fgId,
    "name": name,
    "status": status,
  };
}
