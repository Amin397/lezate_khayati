// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

class CommentModel {
  CommentModel({
    this.liveId,
    this.updatedAt,
    this.userId,
    this.createdAt,
    this.id,
    this.body,
    this.user,
  });

  String? liveId;
  DateTime? updatedAt;
  String? userId;
  DateTime? createdAt;
  int? id;
  String? body;
  User? user;



  static List<CommentModel> listFromJson(List data)=>data.map((e) => CommentModel.fromJson(e)).toList();

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    liveId: json["live_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    body: json["body"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "live_id": liveId,
    "updated_at": updatedAt!.toIso8601String(),
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "id": id,
    "body": body,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.name,
    this.id,
    this.avatar,
  });

  String? name;
  int? id;
  String? avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    id: json["id"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "avatar": avatar,
  };
}
