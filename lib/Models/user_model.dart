class UserModel {
  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.city,
    this.gender,
    this.address,
    this.postalCode,
    this.birthday,
    this.justified,
    this.refer,
    this.role,
    this.fcmToken,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? avatar;
  String? city;
  String? gender;
  String? address;
  String? postalCode;
  String? birthday;
  int? justified;
  String? refer;
  String? role;
  String? fcmToken;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
    city: json["city"],
    gender: json["gender"],
    address: json["address"],
    postalCode: json["postal_code"],
    birthday: json["birthday"],
    justified: json["justified"],
    refer: json["refer"],
    role: json["role"],
    fcmToken: json["fcm_token"],
    phone: json["phone"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "city": city,
    "gender": gender,
    "address": address,
    "postal_code": postalCode,
    "birthday": birthday,
    "justified": justified,
    "refer": refer,
    "role": role,
    "fcm_token": fcmToken,
    "phone": phone,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
