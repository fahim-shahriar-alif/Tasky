// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerAdapter extends TypeAdapter<Prayer> {
  @override
  final int typeId = 4;

  @override
  Prayer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prayer(
      name: fields[0] as String,
      arabicName: fields[1] as String,
      time: fields[2] as DateTime,
      isCompleted: fields[3] as bool,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Prayer obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.arabicName)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
