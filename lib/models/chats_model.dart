import 'package:chat_server/models/chatting_model.dart';
import 'package:hive/hive.dart';

part 'chats_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String chatType;

  @HiveField(3)
  final List<int> participants;

  @HiveField(4)
  final String link;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? picture;

  @HiveField(7)
  List<ChattingModel> messages;

  ChatModel({
    this.id,
    required this.name,
    required this.chatType,
    required this.participants,
    required this.link,
    this.description,
    this.picture,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      chatType: json['chatType'] as String,
      participants: List<int>.from(json['participants'] as List<dynamic>),
      link: json['link'] as String,
      description: json['description'] as String?,
      picture: json['picture'] as String?,
      messages: (json['messages'] as List<dynamic>)
          .map((item) => ChattingModel.fromJson(item as Map<String, dynamic>))
          .toList(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chatType': chatType,
      'participants': participants,
      'link': link,
      'description': description,
      'picture': picture,
      'messages': messages.map((item) => item.toJson()).toList(),
    };
  }
}
