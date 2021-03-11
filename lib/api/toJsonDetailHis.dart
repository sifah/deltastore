import 'dart:convert';

DetailHistory detailHistoryFromJson(String str) => DetailHistory.fromJson(json.decode(str));

String detailHistoryToJson(DetailHistory data) => json.encode(data.toJson());

class DetailHistory {
  DetailHistory({
    this.date,
    this.orderIdRes,
    this.orderId,
    this.table,
    this.by,
    this.data,
    this.end,
    this.netPrice,
  });

  String date;
  String orderIdRes;
  String orderId;
  String table;
  String by;
  List<Datum> data;
  List<End> end;
  String netPrice;

  factory DetailHistory.fromJson(Map<String, dynamic> json) => DetailHistory(
    date: json["date"],
    orderIdRes: json["order_id_res"],
    orderId: json["order_id"],
    table: json["table"],
    by: json["by"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    end: List<End>.from(json["end"].map((x) => End.fromJson(x))),
    netPrice: json["net_price"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "order_id_res": orderIdRes,
    "order_id": orderId,
    "table": table,
    "by": by,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "end": List<dynamic>.from(end.map((x) => x.toJson())),
    "net_price": netPrice,
  };
}

class Datum {
  Datum({
    this.text,
    this.number,
    this.details,
    this.status,
    this.sum,
    this.toppings,
    this.comment,
  });

  String text;
  String number;
  List<dynamic> details;
  String status;
  String sum;
  List<dynamic> toppings;
  String comment;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    text: json["text"],
    number: json["number"],
    details: List<dynamic>.from(json["details"].map((x) => x)),
    status: json["status"],
    sum: json["sum"],
    toppings: List<dynamic>.from(json["toppings"].map((x) => x)),
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "number": number,
    "details": List<dynamic>.from(details.map((x) => x)),
    "status": status,
    "sum": sum,
    "toppings": List<dynamic>.from(toppings.map((x) => x)),
    "comment": comment,
  };
}

class End {
  End({
    this.text,
    this.sum,
  });

  String text;
  String sum;

  factory End.fromJson(Map<String, dynamic> json) => End(
    text: json["text"],
    sum: json["sum"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "sum": sum,
  };
}
