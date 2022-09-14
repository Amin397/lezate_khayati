import 'package:lezate_khayati/Plugins/get/get.dart';

class SingleArticleModel {
  SingleArticleModel({
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
    this.comments,
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
  RxBool? isBookmarked;
  int? reviews;
  int? reviewsRating;
  List<Comment>? comments;

  factory SingleArticleModel.fromJson(Map<String, dynamic> json) => SingleArticleModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isBookmarked: json["isBookmarked"] == true ?true.obs:false.obs,
    reviews: json["reviews"],
    reviewsRating: json["reviewsRating"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
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
    "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.id,
    this.userId,
    this.postId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? userId;
  String? postId;
  String? text;
  dynamic createdAt;
  dynamic updatedAt;
  User? user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    userId: json["user_id"],
    postId: json["post_id"],
    text: json["text"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "post_id": postId,
    "text": text,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
