import 'dart:convert';

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.fId,
    this.name,
    this.status,
    this.picId,
    this.price,
    this.detail,
    this.groupId,
    this.picUrl,
    this.groupName,
  });

  String fId;
  String name;
  String status;
  String picId;
  String price;
  String detail;
  String groupId;
  String picUrl;
  String groupName;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    fId: json["f_id"],
    name: json["name"],
    status: json["status"],
    picId: json["pic_id"],
    price: json["price"],
    detail: json["detail"],
    groupId: json["group_id"],
    picUrl: json["pic_url"],
    groupName: json["group_name"],
  );

  Map<String, dynamic> toJson() => {
    "f_id": fId,
    "name": name,
    "status": status,
    "pic_id": picId,
    "price": price,
    "detail": detail,
    "group_id": groupId,
    "pic_url": picUrl,
    "group_name": groupName,
  };
}
