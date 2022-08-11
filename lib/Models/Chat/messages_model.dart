
class MessagesModel {
  MessagesModel({
    this.id,
    this.userId,
    this.chatId,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.isMe,
    this.user,
  });

  int? id;
  String? userId;
  String? chatId;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isMe;
  User? user;


  static List<MessagesModel> listFromJson(List data)=>data.map((e) => MessagesModel.fromJson(e)).toList();

  factory MessagesModel.fromJson(Map<String, dynamic> json) => MessagesModel(
    id: json["id"],
    userId: json["user_id"],
    chatId: json["chat_id"],
    body: json["body"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isMe: json["isMe"],
    user: User.fromJson(json["user"]),
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
  };
}

class User {
  User({
    this.id,
    this.name,
    this.avatar,
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
    "refer": refer,
    "role": role,
    "fcm_token": fcmToken,
    "phone": phone,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
