import 'dart:convert';

List<StorePhoto> storePhotoFromJson(String str) => List<StorePhoto>.from(json.decode(str).map((x) => StorePhoto.fromJson(x)));

String storePhotoToJson(List<StorePhoto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StorePhoto {
  StorePhoto({
    this.id,
    this.title,
    this.name,
    this.date,
    this.creatBy,
  });

  String id;
  String title;
  String name;
  DateTime date;
  String creatBy;

  factory StorePhoto.fromJson(Map<String, dynamic> json) => StorePhoto(
    id: json["id"],
    title: json["title"],
    name: json["name"],
    date: DateTime.parse(json["date"]),
    creatBy: json["creat_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "name": name,
    "date": date.toIso8601String(),
    "creat_by": creatBy,
  };
}
