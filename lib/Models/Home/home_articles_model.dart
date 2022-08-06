import 'package:lezate_khayati/Plugins/get/get.dart';

class HomeArticlesModel {
  HomeArticlesModel({
    this.id,
    this.name,
    this.slug,
    this.catId,
    this.content,
    this.img,
    this.views,
    this.createdAt,
    required this.visible,
    this.updatedAt,
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
RxBool visible;

  static List<HomeArticlesModel> listFromJson(List data)=>data.map((e) => HomeArticlesModel.fromJson(e)).toList();

  factory HomeArticlesModel.fromJson(Map<String, dynamic> json) => HomeArticlesModel(
    id: json["id"],
    name: json["name"],
    visible: true.obs,
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
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
  };
}
