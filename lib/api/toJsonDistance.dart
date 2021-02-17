import 'dart:convert';

Distance distanceFromJson(String str) => Distance.fromJson(json.decode(str));

String distanceToJson(Distance data) => json.encode(data.toJson());

class Distance {
  Distance({
    this.data,
    this.destination,
    this.transfer,
  });

  List<Datum> data;
  bool destination;
  bool transfer;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    destination: json["destination"],
    transfer: json["transfer"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "destination": destination,
    "transfer": transfer,
  };
}

class Datum {
  Datum({
    this.number,
    this.price,
    this.hashKey,
  });

  int number;
  int price;
  String hashKey;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    number: json["number"],
    price: json["price"],
    hashKey: json["\u0024\u0024hashKey"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "price": price,
    "\u0024\u0024hashKey": hashKey,
  };
}
