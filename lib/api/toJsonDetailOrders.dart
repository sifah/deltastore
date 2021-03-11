// To parse this JSON data, do
//
//     final detailOrders = detailOrdersFromJson(jsonString);

import 'dart:convert';

DetailOrders detailOrdersFromJson(String str) => DetailOrders.fromJson(json.decode(str));

String detailOrdersToJson(DetailOrders data) => json.encode(data.toJson());

class DetailOrders {
  DetailOrders({
    this.orderId,
    this.timeStart,
    this.timeEnd,
    this.memberId,
    this.people,
    this.sumTable,
    this.hourNumber,
    this.title,
    this.comment,
    this.idResAuto,
    this.status,
    this.paymentBy,
    this.paymentType,
    this.del,
    this.creBy,
    this.upBy,
    this.upDate,
    this.cancelReason,
    this.refer,
    this.sumPrice,
    this.orderIdRes,
    this.priceStart,
    this.pricePerHour,
    this.priceCharge,
    this.priceFood,
    this.priceHour,
    this.priceBuffet,
    this.fine,
    this.lang,
    this.payments,
    this.changeMoney,
    this.discounts,
    this.finish,
    this.address,
    this.memberLatLong,
    this.memberGiveaway,
    this.isDelivery,
    this.priceSend,
    this.rider,
    this.bgId,
    this.location,
    this.member,
    this.orderSlip,
    this.items,
  });

  String orderId;
  DateTime timeStart;
  String timeEnd;
  String memberId;
  String people;
  String sumTable;
  String hourNumber;
  String title;
  dynamic comment;
  String idResAuto;
  String status;
  String paymentBy;
  String paymentType;
  String del;
  String creBy;
  String upBy;
  DateTime upDate;
  String cancelReason;
  String refer;
  String sumPrice;
  String orderIdRes;
  String priceStart;
  String pricePerHour;
  String priceCharge;
  String priceFood;
  String priceHour;
  String priceBuffet;
  String fine;
  String lang;
  String payments;
  String changeMoney;
  String discounts;
  String finish;
  Address address;
  String memberLatLong;
  String memberGiveaway;
  String isDelivery;
  String priceSend;
  String rider;
  String bgId;
  Location location;
  Member member;
  List<OrderSlip> orderSlip;
  List<Item> items;

  factory DetailOrders.fromJson(Map<String, dynamic> json) => DetailOrders(
    orderId: json["order_id"],
    timeStart: DateTime.parse(json["time_start"]),
    timeEnd: json["time_end"],
    memberId: json["member_id"],
    people: json["people"],
    sumTable: json["sum_table"],
    hourNumber: json["hour_number"],
    title: json["title"],
    comment: json["comment"],
    idResAuto: json["id_res_auto"],
    status: json["status"],
    paymentBy: json["payment_by"],
    paymentType: json["payment_type"],
    del: json["del"],
    creBy: json["cre_by"],
    upBy: json["up_by"],
    upDate: DateTime.parse(json["up_date"]),
    cancelReason: json["cancel_reason"],
    refer: json["refer"],
    sumPrice: json["sum_price"],
    orderIdRes: json["order_id_res"],
    priceStart: json["price_start"],
    pricePerHour: json["price_per_hour"],
    priceCharge: json["price_charge"],
    priceFood: json["price_food"],
    priceHour: json["price_hour"],
    priceBuffet: json["price_buffet"],
    fine: json["fine"],
    lang: json["lang"],
    payments: json["payments"],
    changeMoney: json["change_money"],
    discounts: json["discounts"],
    finish: json["finish"],
    address: Address.fromJson(json["address"]),
    memberLatLong: json["member_lat_long"],
    memberGiveaway: json["member_giveaway"],
    isDelivery: json["is_delivery"],
    priceSend: json["price_send"],
    rider: json["rider"],
    bgId: json["bg_id"],
    location: Location.fromJson(json["location"]),
    member: Member.fromJson(json["member"]),
    orderSlip: List<OrderSlip>.from(json["order_slip"].map((x) => OrderSlip.fromJson(x))),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "time_start": timeStart.toIso8601String(),
    "time_end": timeEnd,
    "member_id": memberId,
    "people": people,
    "sum_table": sumTable,
    "hour_number": hourNumber,
    "title": title,
    "comment": comment,
    "id_res_auto": idResAuto,
    "status": status,
    "payment_by": paymentBy,
    "payment_type": paymentType,
    "del": del,
    "cre_by": creBy,
    "up_by": upBy,
    "up_date": upDate.toIso8601String(),
    "cancel_reason": cancelReason,
    "refer": refer,
    "sum_price": sumPrice,
    "order_id_res": orderIdRes,
    "price_start": priceStart,
    "price_per_hour": pricePerHour,
    "price_charge": priceCharge,
    "price_food": priceFood,
    "price_hour": priceHour,
    "price_buffet": priceBuffet,
    "fine": fine,
    "lang": lang,
    "payments": payments,
    "change_money": changeMoney,
    "discounts": discounts,
    "finish": finish,
    "address": address.toJson(),
    "member_lat_long": memberLatLong,
    "member_giveaway": memberGiveaway,
    "is_delivery": isDelivery,
    "price_send": priceSend,
    "rider": rider,
    "bg_id": bgId,
    "location": location.toJson(),
    "member": member.toJson(),
    "order_slip": List<dynamic>.from(orderSlip.map((x) => x.toJson())),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Address {
  Address({
    this.address,
    this.distance,
    this.duration,
  });

  String address;
  String distance;
  String duration;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json["address"],
    distance: json["distance"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "distance": distance,
    "duration": duration,
  };
}

class Item {
  Item({
    this.odId,
    this.fId,
    this.price,
    this.totalPrice,
    this.details,
    this.toppings,
    this.count,
    this.status,
    this.okId,
    this.q,
    this.name,
    this.comments,
    this.html,
  });

  String odId;
  String fId;
  String price;
  String totalPrice;
  List<dynamic> details;
  List<dynamic> toppings;
  String count;
  String status;
  String okId;
  String q;
  Name name;
  String comments;
  String html;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    odId: json["od_id"],
    fId: json["f_id"],
    price: json["price"],
    totalPrice: json["total_price"],
    details: List<dynamic>.from(json["details"].map((x) => x)),
    toppings: List<dynamic>.from(json["toppings"].map((x) => x)),
    count: json["count"],
    status: json["status"],
    okId: json["ok_id"],
    q: json["q"],
    name: Name.fromJson(json["name"]),
    comments: json["comments"],
    html: json["html"],
  );

  Map<String, dynamic> toJson() => {
    "od_id": odId,
    "f_id": fId,
    "price": price,
    "total_price": totalPrice,
    "details": List<dynamic>.from(details.map((x) => x)),
    "toppings": List<dynamic>.from(toppings.map((x) => x)),
    "count": count,
    "status": status,
    "ok_id": okId,
    "q": q,
    "name": name.toJson(),
    "comments": comments,
    "html": html,
  };
}

class Name {
  Name({
    this.th,
    this.en,
    this.la,
  });

  String th;
  String en;
  String la;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    th: json["th"],
    en: json["en"],
    la: json["la"],
  );

  Map<String, dynamic> toJson() => {
    "th": th,
    "en": en,
    "la": la,
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Member {
  Member({
    this.mmId,
    this.mmName,
    this.picUrl,
    this.phoneId,
  });

  String mmId;
  String mmName;
  String picUrl;
  String phoneId;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    mmId: json["mm_id"],
    mmName: json["mm_name"],
    picUrl: json["pic_url"],
    phoneId: json["phone_id"],
  );

  Map<String, dynamic> toJson() => {
    "mm_id": mmId,
    "mm_name": mmName,
    "pic_url": picUrl,
    "phone_id": phoneId,
  };
}

class OrderSlip {
  OrderSlip({
    this.idSlip,
    this.idPayType,
    this.imgUrl,
    this.amount,
    this.success,
  });

  String idSlip;
  String idPayType;
  String imgUrl;
  String amount;
  String success;

  factory OrderSlip.fromJson(Map<String, dynamic> json) => OrderSlip(
    idSlip: json["id_slip"],
    idPayType: json["id_pay_type"],
    imgUrl: json["img_url"],
    amount: json["amount"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "id_slip": idSlip,
    "id_pay_type": idPayType,
    "img_url": imgUrl,
    "amount": amount,
    "success": success,
  };
}
