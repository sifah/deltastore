import 'dart:convert';

List<History> historyFromJson(String str) => List<History>.from(json.decode(str).map((x) => History.fromJson(x)));

String historyToJson(List<History> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class History {
  History({
    this.orderId,
    this.sumTable,
    this.title,
    this.comment,
    this.sumPrice,
    this.orderIdRes,
  });

  String orderId;
  List<dynamic> sumTable;
  String title;
  String comment;
  String sumPrice;
  String orderIdRes;

  factory History.fromJson(Map<String, dynamic> json) => History(
    orderId: json["order_id"],
    sumTable: List<dynamic>.from(json["sum_table"].map((x) => x)),
    title: json["title"],
    comment: json["comment"],
    sumPrice: json["sum_price"],
    orderIdRes: json["order_id_res"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "sum_table": List<dynamic>.from(sumTable.map((x) => x)),
    "title": title,
    "comment": comment,
    "sum_price": sumPrice,
    "order_id_res": orderIdRes,
  };
}
