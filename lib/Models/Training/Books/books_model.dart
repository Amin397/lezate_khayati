import '../../../Plugins/get/get.dart';

class BooksModel {
  BooksModel({
    this.id,
    this.name,
    this.img,
    this.description,
    this.views,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.reviews,
    this.reviewsrating,
    required this.visible,
  });

  int? id;
  String? name;
  String? img;
  String? description;
  String? views;
  String? link;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? reviews;
  int? reviewsrating;
  RxBool visible;

  static List<BooksModel> listFromJson(List data)=>data.map((e) => BooksModel.fromJson(e)).toList();

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
    id: json["id"],
    name: json["name"],
    img: json["img"],
    description: json["description"],
    views: json["views"],
    visible: true.obs,
    link: json["link"],
    createdAt:json['created_at'] == null?DateTime.now(): DateTime.parse(json["created_at"]),
    updatedAt: json['updated_at'] == null?DateTime.now():DateTime.parse(json["updated_at"]),
    reviews: json["reviews"],
    reviewsrating: json["reviewsrating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img": img,
    "description": description,
    "views": views,
    "link": link,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "reviews": reviews,
    "reviewsrating": reviewsrating,
  };
}
