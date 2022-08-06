import 'package:lezate_khayati/Plugins/get/get.dart';

class MyOrderModel {
  MyOrderModel({
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
    required this.isCollapsed,
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
  RxBool isCollapsed;
  RxBool visible;
  List<int>? date;


  static List<MyOrderModel> listFromJson(List data)=>data.map((e) => MyOrderModel.fromJson(e)).toList();


  factory MyOrderModel.fromJson(Map<String, dynamic> json) => MyOrderModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    catId: json["cat_id"],
    content: json["content"],
    img: json["img"],
    price: json["price"],
    isCollapsed: false.obs,
    views: json["views"],
    date:List<int>.from(json["date"].map((x) => x)),
    visible: true.obs,
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
