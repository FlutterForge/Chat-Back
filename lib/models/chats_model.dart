import 'package:hive/hive.dart';

part 'chats_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String chatType;

  @HiveField(3)
  final List<int> participants;

  @HiveField(4)
  final String link;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? picture;

  @HiveField(7)
  final List<dynamic> messages;

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
      participants: (json['participants'] as List<dynamic>)
          .map((item) => item as int)
          .toList(),
      link: json['link'] as String,
      description: json['description'] as String?,
      picture: json['picture'] as String?,
      messages: List<dynamic>.from(json['messages']),
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
      'messages': messages,
    };
  }
}