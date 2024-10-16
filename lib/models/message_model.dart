import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int sender;

  @HiveField(2)
  dynamic message;

  MessageModel({
    required this.id,
    required this.sender,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      sender: json['sender'] as int,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
    };
  }
}
