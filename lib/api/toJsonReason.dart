
import 'dart:convert';

List<Reason> reasonFromJson(String str) => List<Reason>.from(json.decode(str).map((x) => Reason.fromJson(x)));

String reasonToJson(List<Reason> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reason {
  Reason({
    this.reasonId,
    this.title,
  });

  String reasonId;
  String title;

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
    reasonId: json["reason_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "reason_id": reasonId,
    "title": title,
  };
}
