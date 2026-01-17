import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((task) {
      // For recurring tasks, check if they should occur today
      if (task.isRecurring) {
        return task.shouldOccurOnDate(now);
      }
      
      // For non-recurring tasks, check creation date or due date
      final createdToday = task.createdAt.year == now.year &&
          task.createdAt.month == now.month &&
          task.createdAt.day == now.day;
      
      final dueToday = task.dueDate != null &&
          task.dueDate!.year == now.year &&
          task.dueDate!.month == now.month &&
          task.dueDate!.day == now.day;
      
      return createdToday || dueToday;
    }).toList()
      ..sort((a, b) {
        // Sort by priority (high first) then by creation time
        if (a.priority != b.priority) {
          return b.priority.index.compareTo(a.priority.index);
        }
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  // Get tasks for a specific date
  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      // For recurring tasks, check if they should occur on this date
      if (task.isRecurring) {
        return task.shouldOccurOnDate(date);
      }
      
      // For non-recurring tasks, check creation date or due date
      final createdOnDay = task.createdAt.year == date.year &&
          task.createdAt.month == date.month &&
          task.createdAt.day == date.day;
      
      final dueOnDay = task.dueDate != null &&
          task.dueDate!.year == date.year &&
          task.dueDate!.month == date.month &&
          task.dueDate!.day == date.day;
      
      return createdOnDay || dueOnDay;
    }).toList()
      ..sort((a, b) {
        if (a.priority != b.priority) {
          return b.priority.index.compareTo(a.priority.index);
        }
        return a.createdAt.compareTo(b.createdAt);
      });
  }

  // Get recurring tasks (like classes)
  List<Task> get recurringTasks => _tasks.where((task) => task.isRecurring).toList();

  // Get class tasks specifically
  List<Task> get classTasks => _tasks.where((task) => 
    task.isRecurring && (task.category?.toLowerCase() == 'class' || task.instructor != null)).toList();

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();

  int get completedTasksCount => completedTasks.length;
  int get totalTasksCount => _tasks.length;
  int get todayCompletedCount => todayTasks.where((task) => task.isCompleted).length;
  int get todayTotalCount => todayTasks.length;

  // Load tasks from storage
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = StorageService.getAllTasks();
      _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new task
  Future<void> addTask({
    required String title,
    TaskPriority priority = TaskPriority.medium,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TimeOfDay? endTime,
    String? category,
    bool hasReminder = false,
    DateTime? reminderDateTime,
    bool isRecurring = false,
    List<int>? recurringDays,
    DateTime? recurringEndDate,
    String? location,
    String? instructor,
    double? duration,
  }) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title.trim(),
      priority: priority,
      createdAt: DateTime.now(),
      description: description?.trim(),
      dueDate: dueDate,
      category: category?.trim(),
      hasReminder: hasReminder,
      reminderDateTime: reminderDateTime,
      isRecurring: isRecurring,
      recurringDays: recurringDays,
      recurringEndDate: recurringEndDate,
      location: location?.trim(),
      instructor: instructor?.trim(),
      duration: duration,
      endTime: endTime,
    );

    // Set the due time using the setter
    task.dueTime = dueTime;

    try {
      await StorageService.saveTask(task);
      _tasks.add(task);
      _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
      rethrow;
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    task.isCompleted = !task.isCompleted;
    task.completedAt = task.isCompleted ? DateTime.now() : null;

    try {
      await StorageService.saveTask(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling task completion: $e');
      // Revert the change if save failed
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      rethrow;
    }
  }

  // Toggle task completion for a specific date (for classes)
  Future<void> toggleTaskCompletionForDate(String taskId, DateTime date) async {
    final task = _tasks.firstWhere((t) => t.id == taskId, orElse: () => Task(id: '', title: '', createdAt: DateTime.now()));
    if (task.id.isEmpty) return;

    // For classes with attendance tracking
    if (task.isRecurring && task.instructor != null) {
      // Check if class should occur on this date
      if (!task.shouldOccurOnDate(date)) {
        debugPrint('Class does not occur on this date: $date');
        return; // Don't allow attendance marking for dates when class doesn't occur
      }
      
      // Check if trying to mark attendance for future date
      final today = DateTime.now();
      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      final isPastDate = date.isBefore(DateTime(today.year, today.month, today.day));
      
      if (!isToday && !isPastDate) {
        debugPrint('Cannot mark attendance for future date: $date');
        return; // Don't allow attendance marking for future dates
      }
      
      // For today's class, check if current time allows attendance marking
      if (isToday && task.dueTime != null) {
        final now = DateTime.now();
        final classTime = DateTime(
          now.year,
          now.month,
          now.day,
          task.dueTime!.hour,
          task.dueTime!.minute,
        );
        
        // Only allow attendance marking from class start time onwards
        if (now.isBefore(classTime)) {
          final hour = task.dueTime!.hour == 0 ? 12 : (task.dueTime!.hour > 12 ? task.dueTime!.hour - 12 : task.dueTime!.hour);
          final period = task.dueTime!.hour < 12 ? 'AM' : 'PM';
          final minute = task.dueTime!.minute.toString().padLeft(2, '0');
          debugPrint('Cannot mark attendance before class time. Class starts at: $hour:$minute $period');
          return;
        }
      }
      
      // Use the new attendance system
      final currentlyAttended = task.isAttendedOnDate(date);
      task.markAttendanceForDate(date, !currentlyAttended);
      
      try {
        await StorageService.saveTask(task);
        notifyListeners();
      } catch (e) {
        debugPrint('Error toggling attendance for date: $e');
        // Revert the change if save failed
        task.markAttendanceForDate(date, currentlyAttended);
        rethrow;
      }
    } else {
      // For regular tasks, use the existing logic
      final today = DateTime.now();
      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
      
      if (isToday) {
        // Use regular completion for today
        await toggleTaskCompletion(taskId);
      } else {
        // For past/future dates, we'll toggle the completion state temporarily
        task.isCompleted = !task.isCompleted;
        if (task.isCompleted) {
          // Set completion time to the specified date
          task.completedAt = DateTime(
            date.year,
            date.month,
            date.day,
            DateTime.now().hour,
            DateTime.now().minute,
          );
        } else {
          task.completedAt = null;
        }

        try {
          await StorageService.saveTask(task);
          notifyListeners();
        } catch (e) {
          debugPrint('Error toggling task completion for date: $e');
          // Revert the change if save failed
          task.isCompleted = !task.isCompleted;
          task.completedAt = task.isCompleted ? task.completedAt : null;
          rethrow;
        }
      }
    }
  }

  // Update task
  Future<void> updateTask({
    required String taskId,
    String? title,
    TaskPriority? priority,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TimeOfDay? endTime,
    String? category,
    bool? hasReminder,
    DateTime? reminderDateTime,
    bool? isRecurring,
    List<int>? recurringDays,
    DateTime? recurringEndDate,
    String? location,
    String? instructor,
    double? duration,
  }) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    if (title != null) task.title = title.trim();
    if (priority != null) task.priority = priority;
    if (description != null) task.description = description.trim();
    if (dueDate != null) task.dueDate = dueDate;
    if (dueTime != null) task.dueTime = dueTime;
    if (endTime != null) task.endTime = endTime;
    if (category != null) task.category = category.trim();
    if (hasReminder != null) task.hasReminder = hasReminder;
    if (reminderDateTime != null) task.reminderDateTime = reminderDateTime;
    if (isRecurring != null) task.isRecurring = isRecurring;
    if (recurringDays != null) task.recurringDays = recurringDays;
    if (recurringEndDate != null) task.recurringEndDate = recurringEndDate;
    if (location != null) task.location = location.trim();
    if (instructor != null) task.instructor = instructor.trim();
    if (duration != null) task.duration = duration;

    try {
      await StorageService.saveTask(task);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await StorageService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  // Clear completed tasks
  Future<void> clearCompletedTasks() async {
    final completedTaskIds = _tasks
        .where((task) => task.isCompleted)
        .map((task) => task.id)
        .toList();

    try {
      for (final taskId in completedTaskIds) {
        await StorageService.deleteTask(taskId);
      }
      _tasks.removeWhere((task) => task.isCompleted);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing completed tasks: $e');
      rethrow;
    }
  }
}