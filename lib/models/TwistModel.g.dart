// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TwistModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TwistModelAdapter extends TypeAdapter<TwistModel> {
  @override
  final int typeId = 0;

  @override
  TwistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TwistModel(
      id: fields[0] as int,
      title: fields[1] as String,
      altTitle: fields[2] as String,
      season: fields[3] as int,
      ongoing: fields[4] as bool,
      kitsuId: fields[5] as int,
      slug: fields[6] as String,
      malId: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TwistModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.altTitle)
      ..writeByte(3)
      ..write(obj.season)
      ..writeByte(4)
      ..write(obj.ongoing)
      ..writeByte(5)
      ..write(obj.kitsuId)
      ..writeByte(6)
      ..write(obj.slug)
      ..writeByte(7)
      ..write(obj.malId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
