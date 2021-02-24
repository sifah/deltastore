import 'dart:convert';

ResName resNameFromJson(String str) => ResName.fromJson(json.decode(str));

String resNameToJson(ResName data) => json.encode(data.toJson());

class ResName {
  ResName({
    this.name,
    this.address,
    this.tel,
    this.photoUrl,
  });

  Address name;
  Address address;
  String tel;
  String photoUrl;

  factory ResName.fromJson(Map<String, dynamic> json) => ResName(
    name: Address.fromJson(json["name"]),
    address: Address.fromJson(json["address"]),
    tel: json["tel"],
    photoUrl: json["photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name.toJson(),
    "address": address.toJson(),
    "tel": tel,
    "photo_url": photoUrl,
  };
}

class Address {
  Address({
    this.th,
    this.en,
  });

  String th;
  String en;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    th: json["th"],
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "th": th,
    "en": en,
  };
}
