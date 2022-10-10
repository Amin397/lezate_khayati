import 'package:lezate_khayati/Plugins/get/get.dart';

class ProductCategoryModel {
  ProductCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.img,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.children,
    required this.visible,
  });

  int? id;
  String? name;
  String? slug;
  String? img;
  String? parentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxBool visible;
  List<ProductCategoryModel>? children;




  static List<ProductCategoryModel> listFromJson(List data)=>data.map((e) => ProductCategoryModel.fromJson(e)).toList();

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    img: json["img"],
    visible:true.obs,
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    children: List<ProductCategoryModel>.from(json["children"].map((x) => ProductCategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "img": img,
    "parent_id": parentId == null ? null : parentId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "children": List<dynamic>.from(children!.map((x) => x.toJson())),
  };
}
