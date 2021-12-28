// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FavouritedModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouritedModelAdapter extends TypeAdapter<FavouritedModel> {
  @override
  final int typeId = 4;

  @override
  FavouritedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouritedModel(
      slug: fields[0] as String,
      coverURL: fields[1] as String,
      posterURL: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavouritedModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.coverURL)
      ..writeByte(2)
      ..write(obj.posterURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouritedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
