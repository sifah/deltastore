import 'dart:convert';

List<Orders> ordersFromJson(String str) => List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  Orders({
    this.orderId,
    this.memberId,
    this.timeStart,
    this.comment,
    this.status,
    this.paymentType,
    this.sumPrice,
    this.orderIdRes,
    this.priceFood,
    this.address,
    this.memberLatLong,
    this.memberGiveaway,
    this.isDelivery,
    this.priceSend,
    this.rider,
    this.member,
    this.slip,
  });

  String orderId;
  String memberId;
  String timeStart;
  String comment;
  String status;
  String paymentType;
  String sumPrice;
  String orderIdRes;
  String priceFood;
  Address address;
  MemberLatLong memberLatLong;
  String memberGiveaway;
  String isDelivery;
  String priceSend;
  String rider;
  Member member;
  dynamic slip;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    orderId: json["order_id"],
    memberId: json["member_id"],
    timeStart: json["time_start"],
    comment: json["comment"] == null ? null : json["comment"],
    status: json["status"],
    paymentType: json["payment_type"],
    sumPrice: json["sum_price"],
    orderIdRes: json["order_id_res"],
    priceFood: json["price_food"],
    address: Address.fromJson(json["address"]),
    memberLatLong: MemberLatLong.fromJson(json["member_lat_long"]),
    memberGiveaway: json["member_giveaway"],
    isDelivery: json["is_delivery"],
    priceSend: json["price_send"],
    rider: json["rider"],
    member: Member.fromJson(json["member"]),
    slip: json["slip"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "member_id": memberId,
    "time_start": timeStart,
    "comment": comment == null ? null : comment,
    "status": status,
    "payment_type": paymentType,
    "sum_price": sumPrice,
    "order_id_res": orderIdRes,
    "price_food": priceFood,
    "address": address.toJson(),
    "member_lat_long": memberLatLong.toJson(),
    "member_giveaway": memberGiveaway,
    "is_delivery": isDelivery,
    "price_send": priceSend,
    "rider": rider,
    "member": member.toJson(),
    "slip": slip,
  };
}

class Address {
  Address({
    this.address,
    this.distance,
    this.duration,
  });

  String address;
  dynamic distance;
  dynamic duration;

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

class Member {
  Member({
    this.mmId,
    this.phoneId,
    this.mmName,
    this.picUrl,
    this.userId,
  });

  String mmId;
  String phoneId;
  String mmName;
  String picUrl;
  String userId;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    mmId: json["mm_id"],
    phoneId: json["phone_id"],
    mmName: json["mm_name"],
    picUrl: json["pic_url"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "mm_id": mmId,
    "phone_id": phoneId,
    "mm_name": mmName,
    "pic_url": picUrl,
    "userId": userId,
  };
}

class MemberLatLong {
  MemberLatLong({
    this.lat,
    this.lng,
  });

  String lat;
  String lng;

  factory MemberLatLong.fromJson(Map<String, dynamic> json) => MemberLatLong(
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class SlipClass {
  SlipClass({
    this.idSlip,
    this.imgUrl,
    this.amount,
    this.success,
  });

  String idSlip;
  String imgUrl;
  String amount;
  String success;

  factory SlipClass.fromJson(Map<String, dynamic> json) => SlipClass(
    idSlip: json["id_slip"],
    imgUrl: json["img_url"],
    amount: json["amount"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "id_slip": idSlip,
    "img_url": imgUrl,
    "amount": amount,
    "success": success,
  };
}
