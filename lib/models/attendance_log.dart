import 'package:hive/hive.dart';

part 'attendance_log.g.dart';

@HiveType(typeId: 5)
class AttendanceLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String taskId; // The class task ID

  @HiveField(2)
  DateTime date; // The specific date of attendance

  @HiveField(3)
  bool isPresent; // true = attended, false = absent

  @HiveField(4)
  DateTime createdAt;

  AttendanceLog({
    required this.id,
    required this.taskId,
    required this.date,
    required this.isPresent,
    required this.createdAt,
  });

  // Check if log is for a specific date
  bool isForDate(DateTime targetDate) {
    return date.year == targetDate.year &&
        date.month == targetDate.month &&
        date.day == targetDate.day;
  }

  @override
  String toString() {
    return 'AttendanceLog{id: $id, taskId: $taskId, date: $date, isPresent: $isPresent}';
  }
}