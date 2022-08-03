class HomeTopSliderModel {
  HomeTopSliderModel({
    this.id,
    this.name,
    this.img,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? img;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;


  static List<HomeTopSliderModel> listFromJson(List data)=>data.map((e) => HomeTopSliderModel.fromJson(e)).toList();

  factory HomeTopSliderModel.fromJson(Map<String, dynamic> json) => HomeTopSliderModel(
    id: json["id"],
    name: json["name"],
    img: json["img"],
    url: json["url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img": img,
    "url": url,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
