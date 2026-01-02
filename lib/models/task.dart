import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  TaskPriority priority;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  String? description;

  @HiveField(7)
  DateTime? dueDate;

  @HiveField(8)
  String? dueTimeString; // Store as "HH:MM" format

  @HiveField(9)
  String? category;

  @HiveField(10)
  bool hasReminder;

  @HiveField(11)
  DateTime? reminderDateTime;

  @HiveField(12)
  bool isRecurring;

  @HiveField(13)
  List<int>? recurringDays; // 1=Monday, 2=Tuesday, ..., 7=Sunday

  @HiveField(14)
  DateTime? recurringEndDate;

  @HiveField(15)
  String? location;

  @HiveField(16)
  String? instructor; // For classes

  @HiveField(17)
  double? duration; // Duration in hours (e.g., 1.5 for 1.5 hours)

  @HiveField(18)
  String? endTimeString; // Store as "HH:MM" format

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    required this.createdAt,
    this.completedAt,
    this.description,
    this.dueDate,
    this.category,
    this.hasReminder = false,
    this.reminderDateTime,
    this.isRecurring = false,
    this.recurringDays,
    this.recurringEndDate,
    this.location,
    this.instructor,
    this.duration,
    TimeOfDay? endTime,
  }) : endTimeString = endTime != null ? '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}' : null;

  // Helper getter to convert string back to TimeOfDay
  TimeOfDay? get dueTime {
    if (dueTimeString == null) return null;
    final parts = dueTimeString!.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  // Helper setter to convert TimeOfDay to string
  set dueTime(TimeOfDay? time) {
    if (time == null) {
      dueTimeString = null;
    } else {
      dueTimeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // Helper getter to convert string back to TimeOfDay for end time
  TimeOfDay? get endTime {
    if (endTimeString == null) return null;
    final parts = endTimeString!.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  // Helper setter to convert TimeOfDay to string for end time
  set endTime(TimeOfDay? time) {
    if (time == null) {
      endTimeString = null;
    } else {
      endTimeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // Helper method to get priority color
  String get priorityColor {
    switch (priority) {
      case TaskPriority.high:
        return '#F44336'; // Red
      case TaskPriority.medium:
        return '#FF9800'; // Orange
      case TaskPriority.low:
        return '#4CAF50'; // Green
    }
  }

  // Helper method to get priority text
  String get priorityText {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  // Check if task is for today
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // Check if task is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  // Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  // Get formatted due date and time
  String? get formattedDueDateTime {
    if (dueDate == null) return null;
    
    final dateFormat = DateFormat('MMM d, y');
    String result = dateFormat.format(dueDate!);
    
    final timeOfDay = dueTime;
    if (timeOfDay != null) {
      final timeFormat = DateFormat('h:mm a');
      final dateTime = DateTime(
        dueDate!.year,
        dueDate!.month,
        dueDate!.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
      result += ' at ${timeFormat.format(dateTime)}';
    }
    
    return result;
  }

  // Get tags as comma-separated string
  String get tagsString {
    return '';
  }

  // Get recurring days as readable string
  String get recurringDaysString {
    if (recurringDays == null || recurringDays!.isEmpty) return '';
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return recurringDays!.map((day) => dayNames[day - 1]).join(', ');
  }

  // Check if task should occur on a specific date
  bool shouldOccurOnDate(DateTime date) {
    if (!isRecurring) {
      return dueDate != null && _isSameDay(dueDate!, date);
    }

    // Check if date is within recurring range
    if (recurringEndDate != null && date.isAfter(recurringEndDate!)) {
      return false;
    }

    // Check if date is after creation date
    if (date.isBefore(createdAt)) {
      return false;
    }

    // Check if day of week matches
    final dayOfWeek = date.weekday; // 1=Monday, 7=Sunday
    return recurringDays?.contains(dayOfWeek) ?? false;
  }

  // Get formatted duration
  String get formattedDuration {
    if (duration == null) return '';
    if (duration! == duration!.toInt()) {
      return '${duration!.toInt()}h';
    }
    return '${duration}h';
  }

  // Get formatted time range (start - end time)
  String get formattedTimeRange {
    if (dueTime == null) return '';
    if (endTime == null) return _formatTime(dueTime!);
    
    // Format both times
    final startTime = dueTime!;
    final endTimeValue = endTime!;
    
    return '${_formatTime(startTime)} - ${_formatTime(endTimeValue)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour < 12 ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    
    return '$hour:$minute $period';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, isCompleted: $isCompleted, priority: $priority}';
  }
}