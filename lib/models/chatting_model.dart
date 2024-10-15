import 'package:hive/hive.dart';

part 'chatting_model.g.dart';

@HiveType(typeId: 2)
class ChattingModel {
  @HiveField(0)
  final int sender;

  @HiveField(1)
  dynamic message;

  ChattingModel({
    required this.sender,
    required this.message,
  });

  factory ChattingModel.fromJson(Map<String, dynamic> json) {
    return ChattingModel(
      sender: json['sender'] as int,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
    };
  }
}
