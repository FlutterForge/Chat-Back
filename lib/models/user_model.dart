
import 'package:hive/hive.dart';

part "user_model.g.dart";

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String? profilePicture;
  @HiveField(4)
  final String? bio;
  @HiveField(5)
  final bool isOnline;
  @HiveField(6)
  UserModel({
    this.id = 0,
    required this.username,
    required this.phoneNumber,
    this.profilePicture,
    this.bio,
    this.isOnline = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ,
      phoneNumber: json['phoneNumber'] ,
      profilePicture: json['profilePicture'] ,
      bio: json['bio'] ,
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'bio': bio,
      'isOnline': isOnline,
    };
  }
}
