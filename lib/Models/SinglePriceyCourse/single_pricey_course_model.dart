import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';
import 'package:video_player/video_player.dart';

class SinglePriceyCourseModel {
  SinglePriceyCourseModel({
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
    this.totalVideos,
    this.isBought,
    this.update,
    this.reviews,
    this.reviewsRating,
    this.videos,
    this.comments,
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
  int? totalVideos;
  bool? isBought;
  List<int>? update;
  int? reviews;
  dynamic reviewsRating;
  List<Video>? videos;
  List<Comment>? comments;

  factory SinglePriceyCourseModel.fromJson(Map<String, dynamic> json) =>
      SinglePriceyCourseModel(
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
        views: json["views"],
        totalVideos: json["totalVideos"],
        isBought: json["isBought"],
        update: List<int>.from(json["update"].map((x) => x)),
        reviews: json["reviews"],
        reviewsRating: json["reviewsRating"],
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
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
        "totalVideos": totalVideos,
        "isBought": isBought,
        "update": List<dynamic>.from(update!.map((x) => x)),
        "reviews": reviews,
        "reviewsRating": reviewsRating,
        "videos": List<dynamic>.from(videos!.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.id,
    this.userId,
    this.courseId,
    this.parentId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  int? id;
  String? userId;
  String? courseId;
  String? parentId;
  String? text;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        text: json["text"],
        createdAt: (json["created_at"] != null)
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: (json["updated_at"] != null)
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "parent_id": parentId == null ? null : parentId,
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

class Video {
  Video({
    this.id,
    this.courseId,
    this.name,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.isInit,
    this.thumb,
    required this.videoController,
    this.chewieController,
  });

  int? id;
  String? courseId;
  String? name;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;
  File? thumb;
  VideoPlayerController videoController;
  RxBool? isInit;
  ChewieController? chewieController;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        courseId: json["course_id"],
        name: json["name"],
        url: json["url"],
        isInit: false.obs,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        videoController: VideoPlayerController.network(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "name": name,
        "url": url,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
