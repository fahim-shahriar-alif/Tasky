import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/task_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/add_class_dialog.dart';
import '../widgets/add_habit_dialog.dart';
import '../widgets/app_logo.dart';
import 'calendar_screen.dart';
import 'tasks_screen.dart';
import 'habits_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalendarScreen(),
    const TasksScreen(),
    const HabitsScreen(),
    const AnalyticsScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Tasks',
    'Habits',
    'Analytics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SvgTaskyLogo(size: 32, showText: false),
            const SizedBox(width: 12),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode 
                    ? LucideIcons.sun 
                    : LucideIcons.moon,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDarkMode 
                  ? 'Switch to Light Mode' 
                  : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.checkSquare),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.target),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.barChart3),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_currentIndex == 1) {
      // Tasks screen - show two buttons for Task and Class with modern design
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: "add_class",
            onPressed: _showAddClassDialog,
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            elevation: 8,
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('🎓', style: TextStyle(fontSize: 16)),
            ),
            label: const Text(
              'Class',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: "add_task",
            onPressed: _showAddTaskDialog,
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 8,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(LucideIcons.plus, size: 18),
            ),
            label: const Text(
              'Task',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      );
    } else if (_currentIndex == 2) {
      // Habits screen - show habit button with modern design
      return FloatingActionButton.extended(
        heroTag: "add_habit",
        onPressed: _showAddHabitDialog,
        backgroundColor: const Color(0xFF06B6D4),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(LucideIcons.target, size: 18),
        ),
        label: const Text(
          'Habit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
    }
    return null;
  }

  void _showAddClassDialog() {
    showDialog(
      context: context,
      builder: (context) => AddClassDialog(
        onSave: ({
          required String title,
          required TaskPriority priority,
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
          final taskProvider = Provider.of<TaskProvider>(context, listen: false);
          await taskProvider.addTask(
            title: title,
            priority: priority,
            description: description,
            dueDate: dueDate,
            dueTime: dueTime,
            endTime: endTime,
            category: category,
            hasReminder: hasReminder,
            reminderDateTime: reminderDateTime,
            isRecurring: isRecurring,
            recurringDays: recurringDays,
            recurringEndDate: recurringEndDate,
            location: location,
            instructor: instructor,
            duration: duration,
          );
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Class added successfully')),
            );
          }
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onSave: ({
          required String title,
          required TaskPriority priority,
          String? description,
          DateTime? dueDate,
          TimeOfDay? dueTime,
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
          final taskProvider = Provider.of<TaskProvider>(context, listen: false);
          await taskProvider.addTask(
            title: title,
            priority: priority,
            description: description,
            dueDate: dueDate,
            dueTime: dueTime,
            endTime: null, // Regular tasks don't have end time
            category: category,
            hasReminder: hasReminder,
            reminderDateTime: reminderDateTime,
            isRecurring: isRecurring,
            recurringDays: recurringDays,
            recurringEndDate: recurringEndDate,
            location: location,
            instructor: instructor,
            duration: duration,
          );
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task added successfully')),
            );
          }
        },
      ),
    );
  }

  void _showAddHabitDialog() {
    showDialog(
      context: context,
      builder: (context) => AddHabitDialog(
        onSave: (name, description) async {
          final habitProvider = Provider.of<HabitProvider>(context, listen: false);
          await habitProvider.addHabit(name: name, description: description);
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Habit added successfully')),
            );
          }
        },
      ),
    );
  }
}