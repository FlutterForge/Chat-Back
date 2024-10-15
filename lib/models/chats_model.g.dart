// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 1;

  @override
  ChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel(
      id: fields[0] as int?,
      name: fields[1] as String,
      chatType: fields[2] as String,
      participants: (fields[3] as List).cast<int>(),
      link: fields[4] as String,
      description: fields[5] as String?,
      picture: fields[6] as String?,
      messages: (fields[7] as List).cast<ChattingModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.chatType)
      ..writeByte(3)
      ..write(obj.participants)
      ..writeByte(4)
      ..write(obj.link)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.picture)
      ..writeByte(7)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
