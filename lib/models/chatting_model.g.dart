// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChattingModelAdapter extends TypeAdapter<ChattingModel> {
  @override
  final int typeId = 2;

  @override
  ChattingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChattingModel(
      sender: fields[0] as int,
      message: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ChattingModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChattingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
