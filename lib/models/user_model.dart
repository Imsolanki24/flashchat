import 'package:newflashchtapp/utilities/constant.dart';

class UserModel {
  final String id;
  final String imageUrl;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    this.imageUrl = defaultImage,
    required this.name,
    required this.email,
  });

  @override
  String toString() =>
      'UserModel{ id: $id, imageUrl: $imageUrl, name: $name, email: $email,}';

  UserModel copyWith({
    String? id,
    String? imageUrl,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
