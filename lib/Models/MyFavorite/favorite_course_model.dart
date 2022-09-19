import 'package:lezate_khayati/Plugins/get/get.dart';

class FavoriteCourseModel {
  FavoriteCourseModel({
    this.id,
    this.collectionId,
    this.type,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.course,
    required this.visible,
  });

  int? id;
  String? collectionId;
  String? type;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxBool visible;
  List<Course>? course;


  static List<FavoriteCourseModel> listFromJson(List data)=>data.map((e) => FavoriteCourseModel.fromJson(e)).toList();

  factory FavoriteCourseModel.fromJson(Map<String, dynamic> json) => FavoriteCourseModel(
    id: json["id"],
    collectionId: json["collection_id"],
    type: json["type"],
    visible: true.obs,
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    course: List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collection_id": collectionId,
    "type": type,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "course": List<dynamic>.from(course!.map((x) => x.toJson())),
  };
}

class Course {
  Course({
    this.id,
    this.name,
    this.type,
    this.slug,
    this.teacher,
    this.poster,
    this.ispin,
    this.description,
    this.excerpt,
    this.price,
    this.img,
    this.views,
    this.update,
    this.reviews,
    this.reviewsRating,
    this.isJustified,
    this.isBookmarked,
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
  String? price;
  String? img;
  String? views;
  List<int>? update;
  int? reviews;
  int? reviewsRating;
  bool? isJustified;
  bool? isBookmarked;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    slug: json["slug"],
    teacher: json["teacher"],
    poster: json["poster"],
    ispin: json["ispin"],
    description: json["description"],
    excerpt: json["excerpt"],
    price: json["price"],
    img: json["img"],
    views: json["views"],
    update: List<int>.from(json["update"].map((x) => x)),
    reviews: json["reviews"],
    reviewsRating: json["reviewsRating"],
    isJustified: json["isJustified"],
    isBookmarked: json["isBookmarked"],
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
    "price": price,
    "img": img,
    "views": views,
    "update": List<dynamic>.from(update!.map((x) => x)),
    "reviews": reviews,
    "reviewsRating": reviewsRating,
    "isJustified": isJustified,
    "isBookmarked": isBookmarked,
  };
}

