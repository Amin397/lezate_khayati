import 'package:lezate_khayati/Plugins/get/get.dart';

class FavoritePostModel {
  FavoritePostModel({
    this.id,
    this.collectionId,
    this.type,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.post,
    required this.visible,
  });

  int? id;
  String? collectionId;
  String? type;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Post>? post;
  RxBool visible;


  static List<FavoritePostModel> listFromJson(List data)=>data.map((e) => FavoritePostModel.fromJson(e)).toList();

  factory FavoritePostModel.fromJson(Map<String, dynamic> json) => FavoritePostModel(
    id: json["id"],
    collectionId: json["collection_id"],
    type: json["type"],
    visible: true.obs,
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    post: List<Post>.from(json["post"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "collection_id": collectionId,
    "type": type,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "post": List<dynamic>.from(post!.map((x) => x.toJson())),
  };
}

class Post {
  Post({
    this.id,
    this.name,
    this.slug,
    this.catId,
    this.content,
    this.img,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.isBookmarked,
    this.reviews,
    this.reviewsRating,
  });

  int? id;
  String? name;
  String? slug;
  String? catId;
  String? content;
  String? img;
  String? views;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isBookmarked;
  int? reviews;
  int? reviewsRating;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isBookmarked: json["isBookmarked"],
    reviews: json["reviews"],
    reviewsRating: json["reviewsRating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "cat_id": catId,
    "content": content,
    "img": img,
    "views": views,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "isBookmarked": isBookmarked,
    "reviews": reviews,
    "reviewsRating": reviewsRating,
  };
}
