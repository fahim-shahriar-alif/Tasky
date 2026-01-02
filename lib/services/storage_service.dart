import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/habit.dart';

class StorageService {
  static const String _tasksBoxName = 'tasks';
  static const String _habitsBoxName = 'habits';
  static const String _habitLogsBoxName = 'habit_logs';

  static Box<Task>? _tasksBox;
  static Box<Habit>? _habitsBox;
  static Box<HabitLog>? _habitLogsBox;

  // Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskPriorityAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(HabitLogAdapter());
    }

    // Open boxes
    _tasksBox = await Hive.openBox<Task>(_tasksBoxName);
    _habitsBox = await Hive.openBox<Habit>(_habitsBoxName);
    _habitLogsBox = await Hive.openBox<HabitLog>(_habitLogsBoxName);
  }

  // Task operations
  static Box<Task> get tasksBox {
    if (_tasksBox == null) {
      throw Exception('Tasks box not initialized. Call StorageService.init() first.');
    }
    return _tasksBox!;
  }

  static Future<void> saveTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String taskId) async {
    await tasksBox.delete(taskId);
  }

  static List<Task> getAllTasks() {
    return tasksBox.values.toList();
  }

  static List<Task> getTodayTasks() {
    final now = DateTime.now();
    return tasksBox.values.where((task) {
      return task.createdAt.year == now.year &&
          task.createdAt.month == now.month &&
          task.createdAt.day == now.day;
    }).toList();
  }

  static Task? getTask(String taskId) {
    return tasksBox.get(taskId);
  }

  // Habit operations
  static Box<Habit> get habitsBox {
    if (_habitsBox == null) {
      throw Exception('Habits box not initialized. Call StorageService.init() first.');
    }
    return _habitsBox!;
  }

  static Future<void> saveHabit(Habit habit) async {
    await habitsBox.put(habit.id, habit);
  }

  static Future<void> deleteHabit(String habitId) async {
    await habitsBox.delete(habitId);
    // Also delete all logs for this habit
    final logsToDelete = _habitLogsBox!.values
        .where((log) => log.habitId == habitId)
        .toList();
    for (final log in logsToDelete) {
      await _habitLogsBox!.delete(log.id);
    }
  }

  static List<Habit> getAllHabits() {
    return habitsBox.values.where((habit) => habit.isActive).toList();
  }

  static Habit? getHabit(String habitId) {
    return habitsBox.get(habitId);
  }

  // Habit log operations
  static Box<HabitLog> get habitLogsBox {
    if (_habitLogsBox == null) {
      throw Exception('Habit logs box not initialized. Call StorageService.init() first.');
    }
    return _habitLogsBox!;
  }

  static Future<void> saveHabitLog(HabitLog log) async {
    await habitLogsBox.put(log.id, log);
  }

  static Future<void> deleteHabitLog(String logId) async {
    await habitLogsBox.delete(logId);
  }

  static List<HabitLog> getHabitLogs(String habitId) {
    return habitLogsBox.values
        .where((log) => log.habitId == habitId)
        .toList();
  }

  static HabitLog? getHabitLogForDate(String habitId, DateTime date) {
    return habitLogsBox.values.firstWhere(
      (log) => log.habitId == habitId && log.isForDate(date),
      orElse: () => HabitLog(
        id: '${habitId}_${date.millisecondsSinceEpoch}',
        habitId: habitId,
        date: date,
        isCompleted: false,
      ),
    );
  }

  // Close all boxes
  static Future<void> close() async {
    await _tasksBox?.close();
    await _habitsBox?.close();
    await _habitLogsBox?.close();
  }
}