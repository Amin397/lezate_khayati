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
    this.gallery,
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
  List<Gallery>? gallery;
  RxBool? visible;

  static List<ProductsModel> listFromJson(List data)=>data.map((e) => ProductsModel.fromJson(e)).toList();

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    price: json["price"],
    visible: true.obs,
    views: json["views"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    date: List<int>.from(json["date"].map((x) => x)),
    // gallery: List<Gallery>.from(json["gallery"].map((x) => Gallery.fromJson(x))),
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
    "date": List<dynamic>.from(date!.map((x) => x)),
    "gallery": List<dynamic>.from(gallery!.map((x) => x.toJson())),
  };
}

class Gallery {
  Gallery({
    this.id,
    this.productId,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? productId;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    id: json["id"],
    productId: json["product_id"],
    url: json["url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "url": url,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
