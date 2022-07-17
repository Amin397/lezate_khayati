class UserModel {
  final int id;
  final String name;
  final String lastName;
  final String mobile;

  UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mobile,
  });

  factory UserModel.fromJson(Map data) => UserModel(
        id: data['id'],
        name: data['name'],
        lastName: data['lastName'],
        mobile: data['mobile'],
      );
}
