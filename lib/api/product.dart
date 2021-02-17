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
    this.type,
    this.picUrl,
  });

  String fId;
  String name;
  String status;
  String picId;
  String price;
  String detail;
  String type;
  String picUrl;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    fId: json["f_id"],
    name: json["name"],
    status: json["status"],
    picId: json["pic_id"],
    price: json["price"],
    detail: json["detail"],
    type: json["type"],
    picUrl: json["pic_url"],
  );

  Map<String, dynamic> toJson() => {
    "f_id": fId,
    "name": name,
    "status": status,
    "pic_id": picId,
    "price": price,
    "detail": detail,
    "type": type,
    "pic_url": picUrl,
  };
}
