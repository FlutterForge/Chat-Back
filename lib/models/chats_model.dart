enum ChatType {
  private,
  group,
  channel,
}

class ChatModel {
  final int? id;
  final String name;
  final ChatType chatType;
  final List<int> participants;
  final String link;
  final String? description;
  final String? picture;
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

  // Convert from JSON (deserialization)
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      chatType: ChatType.values[json['chatType'] as int],
      participants: List<int>.from(json['participants']),
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
      'chatType': chatType.index,
      'participants': participants,
      'link': link,
      'description': description,
      'picture': picture,
      'messages': messages,
    };
  }
}