import 'dart:io';

import 'package:lezate_khayati/Plugins/get/get.dart';

class MessageModel {
  MessageModel({
    this.id,
    this.userId,
    this.chatId,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.isMe,
    this.user,
    this.files,
    required this.isSend,
  });

  int? id;
  String? userId;
  String? chatId;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isMe;
  User? user;
  Files? files;
  RxBool isSend;


  static List<MessageModel> listFromJson(List data){
    return data.map((e) => MessageModel.fromJson(e)).toList();
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["id"],
    userId: json["user_id"],
    chatId: json["chat_id"],
    body: json["body"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isMe: json["isMe"],
    isSend: true.obs,
    user: User.fromJson(json["user"]),

    files:(json["files"] == null)?null: Files.fromJson(json["files"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "chat_id": chatId,
    "body": body,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "isMe": isMe,
    "user": user!.toJson(),
    "files": files!.toJson(),
  };
}

class Files {
  Files({
    this.id,
    this.messageId,
    this.chatId,
    this.userId,
    this.input,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.file,
  });

  int? id;
  String? messageId;
  String? chatId;
  String? userId;
  String? input;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  File? file;

  factory Files.fromJson(Map<String, dynamic> json) => Files(
    id: json["id"],
    messageId: json["message_id"],
    chatId: json["chat_id"],
    userId: json["user_id"],
    input: json["input"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message_id": messageId,
    "chat_id": chatId,
    "user_id": userId,
    "input": input,
    "type": type,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

class User {
  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
