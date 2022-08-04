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
  int? reviewsRating;
  List<dynamic>? videos;
  List<dynamic>? comments;

  factory SinglePriceyCourseModel.fromJson(Map<String, dynamic> json) => SinglePriceyCourseModel(
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
    videos: List<dynamic>.from(json["videos"].map((x) => x)),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
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
    "videos": List<dynamic>.from(videos!.map((x) => x)),
    "comments": List<dynamic>.from(comments!.map((x) => x)),
  };
}
