class UserModel {
  final int? id;
  final String? name;
  final String? lastName;
  final String? mobile;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.lastName,
    this.mobile,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map data) => UserModel(
        id: data['id'],
        name: data['name'],
        lastName: data['lastName'],
        mobile: data['phone'],
        avatar: data['avatar'],
        createdAt: DateTime.parse(data['created_at']),
        updatedAt: DateTime.parse(data['updated_at']),
      );
}
