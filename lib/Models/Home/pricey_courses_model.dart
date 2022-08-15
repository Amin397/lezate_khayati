import 'package:lezate_khayati/Plugins/get/get.dart';

class PriceyCoursesModel {
  PriceyCoursesModel({
    this.id,
    this.name,
    this.type,
    this.slug,
    this.teacher,
    this.poster,
    this.ispin,
    this.description,
    this.excerpt,
    this.gradient,
    this.price,
    this.img,
    this.views,
    this.update,
    this.reviews,
    required this.visible,
    this.reviewsRating,
  });

  int? id;
  String? name;
  String? type;
  String? slug;
  String? teacher;
  String? poster;
  int? ispin;
  String? description;
  String? excerpt;
  String? gradient;
  String? price;
  String? img;
  String? views;
  List<int>? update;
  int? reviews;
  double? reviewsRating;

  RxBool visible;


  static List<PriceyCoursesModel> listFromJson(List data)=>data.map((e) => PriceyCoursesModel.fromJson(e)).toList();


  factory PriceyCoursesModel.fromJson(Map<String, dynamic> json) => PriceyCoursesModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    slug: json["slug"],
    teacher: json["teacher"],
    poster: json["poster"],
    visible: true.obs,
    ispin: json["ispin"],
    description: json["description"],
    excerpt: json["excerpt"],
    gradient: json["gradient"],
    price: json["price"],
    img: json["img"],
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
    "ispin": ispin,
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

