import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<HabitLog> _habitLogs = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  List<HabitLog> get habitLogs => _habitLogs;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  // Get habit logs for selected date
  List<HabitLog> get selectedDateLogs {
    return _habitLogs.where((log) => log.isForDate(_selectedDate)).toList();
  }

  // Get completion status for a habit on selected date
  bool isHabitCompletedOnDate(String habitId, DateTime date) {
    final log = _habitLogs.firstWhere(
      (log) => log.habitId == habitId && log.isForDate(date),
      orElse: () => HabitLog(
        id: '',
        habitId: habitId,
        date: date,
        isCompleted: false,
      ),
    );
    return log.isCompleted;
  }

  // Get habit completion streak
  int getHabitStreak(String habitId) {
    final logs = _habitLogs
        .where((log) => log.habitId == habitId && log.isCompleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (logs.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (final log in logs) {
      final daysDifference = currentDate.difference(log.date).inDays;
      if (daysDifference == streak) {
        streak++;
        currentDate = log.date;
      } else {
        break;
      }
    }

    return streak;
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  // Load habits and logs from storage
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = StorageService.getAllHabits();
      _habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      
      // Load all habit logs
      _habitLogs = [];
      for (final habit in _habits) {
        final logs = StorageService.getHabitLogs(habit.id);
        _habitLogs.addAll(logs);
      }
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new habit
  Future<void> addHabit({
    required String name,
    String? description,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name.trim(),
      description: description?.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await StorageService.saveHabit(habit);
      _habits.add(habit);
      _habits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit: $e');
      rethrow;
    }
  }

  // Update habit
  Future<void> updateHabit({
    required String habitId,
    String? name,
    String? description,
  }) async {
    final habitIndex = _habits.indexWhere((habit) => habit.id == habitId);
    if (habitIndex == -1) return;

    final habit = _habits[habitIndex];
    if (name != null) habit.name = name.trim();
    if (description != null) habit.description = description.trim();

    try {
      await StorageService.saveHabit(habit);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  // Delete habit
  Future<void> deleteHabit(String habitId) async {
    try {
      await StorageService.deleteHabit(habitId);
      _habits.removeWhere((habit) => habit.id == habitId);
      _habitLogs.removeWhere((log) => log.habitId == habitId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  // Toggle habit completion for selected date
  Future<void> toggleHabitCompletion(String habitId) async {
    final existingLogIndex = _habitLogs.indexWhere(
      (log) => log.habitId == habitId && log.isForDate(_selectedDate),
    );

    HabitLog log;
    if (existingLogIndex != -1) {
      // Update existing log
      log = _habitLogs[existingLogIndex];
      log.isCompleted = !log.isCompleted;
    } else {
      // Create new log
      log = HabitLog(
        id: const Uuid().v4(),
        habitId: habitId,
        date: _selectedDate,
        isCompleted: true,
      );
      _habitLogs.add(log);
    }

    try {
      await StorageService.saveHabitLog(log);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling habit completion: $e');
      // Revert the change if save failed
      if (existingLogIndex != -1) {
        log.isCompleted = !log.isCompleted;
      } else {
        _habitLogs.remove(log);
      }
      rethrow;
    }
  }

  // Add note to habit log
  Future<void> addHabitNote(String habitId, String note) async {
    final existingLogIndex = _habitLogs.indexWhere(
      (log) => log.habitId == habitId && log.isForDate(_selectedDate),
    );

    HabitLog log;
    if (existingLogIndex != -1) {
      log = _habitLogs[existingLogIndex];
      log.notes = note.trim();
    } else {
      log = HabitLog(
        id: const Uuid().v4(),
        habitId: habitId,
        date: _selectedDate,
        notes: note.trim(),
      );
      _habitLogs.add(log);
    }

    try {
      await StorageService.saveHabitLog(log);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit note: $e');
      rethrow;
    }
  }
}