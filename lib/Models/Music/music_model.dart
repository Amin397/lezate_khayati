import 'package:audioplayers/audioplayers.dart';
import 'package:lezate_khayati/Plugins/get/get.dart';

class MusicModel {
  MusicModel({
    this.id,
    this.name,
    this.url,
    this.img,
    this.createdAt,
    this.updatedAt,
    this.isPlayed,
    this.audioPlayer,
    this.totalDuration,
    this.isLoading,
    this.position,
    this.isShow,
  });

  int? id;
  String? name;
  String? url;
  String? img;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxBool? isPlayed;
  RxBool? isLoading;
  RxBool? isShow;
  AudioPlayer? audioPlayer;
  Duration? totalDuration;
  Duration? position;

  static List<MusicModel> listFromJson(List data) =>
      data.map((e) => MusicModel.fromJson(e)).toList();

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
      id: json["id"],
      name: json["name"],
      url: json["url"],
      img: json["img"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isPlayed: false.obs,
      isLoading: false.obs,
      isShow: true.obs,
      audioPlayer: AudioPlayer(),
      position: Duration.zero,
      totalDuration: Duration.zero);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "img": img,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
