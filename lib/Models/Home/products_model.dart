import 'package:lezate_khayati/Plugins/get/get.dart';

class ProductsModel {
  ProductsModel({
    this.id,
    this.name,
    this.slug,
    this.catId,
    this.content,
    this.img,
    this.price,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.date,
    required this.visible,
  });

  int? id;
  String? name;
  String? slug;
  String? catId;
  String? content;
  String? img;
  String? price;
  String? views;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<int>? date;
  RxBool visible;

  static List<ProductsModel> listFromJson(List data)=>data.map((e) => ProductsModel.fromJson(e)).toList();

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    id: json["id"],
    visible: true.obs,
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    price: json["price"],
    date: List<int>.from(json["date"].map((x) => x)),
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
    "price": price,
    "views": views,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
