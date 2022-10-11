// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikeAdapter extends TypeAdapter<Like> {
  @override
  final int typeId = 6;

  @override
  Like read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Like(
      likeValue: fields[0] as bool?,
      uid: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Like obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.likeValue)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
