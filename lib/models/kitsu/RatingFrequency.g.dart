// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RatingFrequency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RatingFrequenciesAdapter extends TypeAdapter<RatingFrequencies> {
  @override
  final int typeId = 5;

  @override
  RatingFrequencies read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingFrequencies(
      s2: fields[0] as String,
      s3: fields[1] as String,
      s4: fields[2] as String,
      s5: fields[3] as String,
      s6: fields[4] as String,
      s7: fields[5] as String,
      s8: fields[6] as String,
      s9: fields[7] as String,
      s10: fields[8] as String,
      s11: fields[9] as String,
      s12: fields[10] as String,
      s13: fields[11] as String,
      s14: fields[12] as String,
      s15: fields[13] as String,
      s16: fields[14] as String,
      s17: fields[15] as String,
      s18: fields[16] as String,
      s19: fields[17] as String,
      s20: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RatingFrequencies obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.s2)
      ..writeByte(1)
      ..write(obj.s3)
      ..writeByte(2)
      ..write(obj.s4)
      ..writeByte(3)
      ..write(obj.s5)
      ..writeByte(4)
      ..write(obj.s6)
      ..writeByte(5)
      ..write(obj.s7)
      ..writeByte(6)
      ..write(obj.s8)
      ..writeByte(7)
      ..write(obj.s9)
      ..writeByte(8)
      ..write(obj.s10)
      ..writeByte(9)
      ..write(obj.s11)
      ..writeByte(10)
      ..write(obj.s12)
      ..writeByte(11)
      ..write(obj.s13)
      ..writeByte(12)
      ..write(obj.s14)
      ..writeByte(13)
      ..write(obj.s15)
      ..writeByte(14)
      ..write(obj.s16)
      ..writeByte(15)
      ..write(obj.s17)
      ..writeByte(16)
      ..write(obj.s18)
      ..writeByte(17)
      ..write(obj.s19)
      ..writeByte(18)
      ..write(obj.s20);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingFrequenciesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
