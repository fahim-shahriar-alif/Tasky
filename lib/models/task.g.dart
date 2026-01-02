// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      isCompleted: fields[2] as bool,
      priority: fields[3] as TaskPriority,
      createdAt: fields[4] as DateTime,
      completedAt: fields[5] as DateTime?,
      description: fields[6] as String?,
      dueDate: fields[7] as DateTime?,
      category: fields[9] as String?,
      hasReminder: fields[10] as bool,
      reminderDateTime: fields[11] as DateTime?,
      isRecurring: fields[12] as bool,
      recurringDays: (fields[13] as List?)?.cast<int>(),
      recurringEndDate: fields[14] as DateTime?,
      location: fields[15] as String?,
      instructor: fields[16] as String?,
      duration: fields[17] as double?,
    )
      ..dueTimeString = fields[8] as String?
      ..endTimeString = fields[18] as String?;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.completedAt)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.dueTimeString)
      ..writeByte(9)
      ..write(obj.category)
      ..writeByte(10)
      ..write(obj.hasReminder)
      ..writeByte(11)
      ..write(obj.reminderDateTime)
      ..writeByte(12)
      ..write(obj.isRecurring)
      ..writeByte(13)
      ..write(obj.recurringDays)
      ..writeByte(14)
      ..write(obj.recurringEndDate)
      ..writeByte(15)
      ..write(obj.location)
      ..writeByte(16)
      ..write(obj.instructor)
      ..writeByte(17)
      ..write(obj.duration)
      ..writeByte(18)
      ..write(obj.endTimeString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 0;

  @override
  TaskPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskPriority.low;
      case 1:
        return TaskPriority.medium;
      case 2:
        return TaskPriority.high;
      default:
        return TaskPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.low:
        writer.writeByte(0);
        break;
      case TaskPriority.medium:
        writer.writeByte(1);
        break;
      case TaskPriority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
