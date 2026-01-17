// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceLogAdapter extends TypeAdapter<AttendanceLog> {
  @override
  final int typeId = 5;

  @override
  AttendanceLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceLog(
      id: fields[0] as String,
      taskId: fields[1] as String,
      date: fields[2] as DateTime,
      isPresent: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.isPresent)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
