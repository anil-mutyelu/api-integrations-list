import 'dart:convert';

class Photodata {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  Photodata({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photodata.fromJson(Map<String, dynamic> json) => Photodata(
    albumId: json["albumId"] as int,
    id: json["id"] as int,
    title: json["title"] as String,
    url: json["url"] as String,
    thumbnailUrl: json["thumbnailUrl"] as String,
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId,
    "id": id,
    "title": title,
    "url": url,
    "thumbnailUrl": thumbnailUrl,
  };
}

List<Photodata> photodataFromJson(String str) =>
    List<Photodata>.from(json.decode(str).map((x) => Photodata.fromJson(x)));

String photodataToJson(List<Photodata> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
