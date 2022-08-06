import 'package:lezate_khayati/Plugins/get/get.dart';

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
    this.reviewsRating,
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
  int? reviewsRating;
  RxBool visible;

  static List<BooksModel> listFromJson(List data) =>
      data.map((e) => BooksModel.fromJson(e)).toList();

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        description: json["description"],
        views: json["views"],
        link: json["link"],
        visible: true.obs,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        reviews: json["reviews"],
        reviewsRating: json["reviewsrating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "description": description,
        "views": views,
        "link": link,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "reviews": reviews,
        "reviewsrating": reviewsRating,
      };
}
