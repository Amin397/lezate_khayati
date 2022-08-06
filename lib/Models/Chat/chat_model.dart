import 'package:lezate_khayati/Plugins/get/get.dart';

class ChatRoomsModel {
  ChatRoomsModel({
    this.id,
    this.data,
    required this.visible,
  });

  int? id;
  Data? data;
  RxBool visible;

  static List<ChatRoomsModel> listFromJson(List data) =>
      data.map((e) => ChatRoomsModel.fromJson(e)).toList();

  factory ChatRoomsModel.fromJson(Map<String, dynamic> json) => ChatRoomsModel(
        id: json["id"],
        visible: true.obs,
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.name,
  });

  String? name;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
