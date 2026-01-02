import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isActive;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.isActive = true,
  });

  @override
  String toString() {
    return 'Habit{id: $id, name: $name, isActive: $isActive}';
  }
}

@HiveType(typeId: 3)
class HabitLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String habitId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String? notes;

  HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    this.isCompleted = false,
    this.notes,
  });

  // Check if log is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if log is for a specific date
  bool isForDate(DateTime targetDate) {
    return date.year == targetDate.year &&
        date.month == targetDate.month &&
        date.day == targetDate.day;
  }

  @override
  String toString() {
    return 'HabitLog{id: $id, habitId: $habitId, date: $date, isCompleted: $isCompleted}';
  }
}