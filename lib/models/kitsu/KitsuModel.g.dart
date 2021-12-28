// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KitsuModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KitsuModelAdapter extends TypeAdapter<KitsuModel> {
  @override
  final int typeId = 1;

  @override
  KitsuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KitsuModel(
      id: fields[0] as String,
      rating: fields[1] as String,
      description: fields[2] as String,
      posterImage: fields[3] as String,
      trailerURL: fields[4] as String,
      coverImage: fields[5] as String,
      ratingFrequencies: fields[6] as RatingFrequencies,

    );
  }

  @override
  void write(BinaryWriter writer, KitsuModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.posterImage)
      ..writeByte(4)
      ..write(obj.trailerURL)
      ..writeByte(5)
      ..write(obj.coverImage)
      ..writeByte(6)
      ..write(obj.ratingFrequencies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KitsuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
