import 'package:lezate_khayati/Plugins/get/get.dart';

class MyCourseModel {
  MyCourseModel({
    this.id,
    this.name,
    this.type,
    this.slug,
    this.teacher,
    this.poster,
    this.description,
    this.excerpt,
    this.gradient,
    this.price,
    this.img,
    this.views,
    this.update,
    this.reviews,
    this.reviewsRating,
    required this.visible,
  });

  int? id;
  String? name;
  String? type;
  String? slug;
  String? teacher;
  String? poster;
  String? description;
  String? excerpt;
  String? gradient;
  String? price;
  String? img;
  String? views;
  List<int>? update;
  int? reviews;
  int? reviewsRating;
  RxBool visible;


  static List<MyCourseModel> listFromJson(List data){
    return data.map((e) => MyCourseModel.fromJson(e)).toList();
  }

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    slug: json["slug"],
    teacher: json["teacher"],
    poster: json["poster"],
    description: json["description"],
    excerpt: json["excerpt"],
    gradient: json["gradient"],
    price: json["price"],
    img: json["img"],
    visible: true.obs,
    views: json["views"],
    update: List<int>.from(json["update"].map((x) => x)),
    reviews: json["reviews"],
    reviewsRating: json["reviewsRating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "slug": slug,
    "teacher": teacher,
    "poster": poster,
    "description": description,
    "excerpt": excerpt,
    "gradient": gradient,
    "price": price,
    "img": img,
    "views": views,
    "update": List<dynamic>.from(update!.map((x) => x)),
    "reviews": reviews,
    "reviewsRating": reviewsRating,
  };
}
