
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
    this.files,
  });

  int? id;
  String? userId;
  String? chatId;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isMe;
  User? user;
  FilesClass? files;

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
    files: FilesClass.fromJson(json["files"]),
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
    createdAt: (json["created_at"] != null)?DateTime.parse(json["created_at"]):DateTime.now(),
    updatedAt: (json["updated_at"] != null)?DateTime.parse(json["updated_at"]):DateTime.now(),
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


class FilesClass {
  FilesClass({
    this.id,
    this.messageId,
    this.chatId,
    this.userId,
    this.input,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? messageId;
  String? chatId;
  String? userId;
  String? input;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FilesClass.fromJson(Map<String, dynamic> json) => FilesClass(
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




