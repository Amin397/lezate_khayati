class ArticlesModel {
  ArticlesModel({
    this.id,
    this.name,
    this.slug,
    this.catId,
    this.content,
    this.img,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.comments,
    this.tag,
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
  List<dynamic>? comments;
  List<Tag>? tag;

  static List<ArticlesModel> listFromJson(List data) =>
      data.map((e) => ArticlesModel.fromJson(e)).toList();

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => ArticlesModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
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
    "comments": List<dynamic>.from(comments!.map((x) => x)),
    "tag": List<dynamic>.from(tag!.map((x) => x.toJson())),
  };
}

class Tag {
  Tag({
    this.id,
    this.name,
    this.type,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.laravelThroughKey,
  });

  int? id;
  String? name;
  String? type;
  String? slug;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? laravelThroughKey;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    slug: json["slug"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    laravelThroughKey: json["laravel_through_key"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "slug": slug,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "laravel_through_key": laravelThroughKey,
  };
}
