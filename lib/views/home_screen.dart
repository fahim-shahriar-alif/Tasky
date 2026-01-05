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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    if (_currentIndex == 0) {
      // Home screen - show expandable speed dial
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Task option
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value,
                  child: _isExpanded
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _buildSpeedDialOption(
                            'Task',
                            LucideIcons.checkSquare,
                            ThemeProvider.gradientColors[4],
                            () {
                              _toggleExpanded();
                              _showAddTaskDialog();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
          
          // Class option
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value,
                  child: _isExpanded
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _buildSpeedDialOption(
                            'Class',
                            LucideIcons.graduationCap,
                            ThemeProvider.gradientColors[1],
                            () {
                              _toggleExpanded();
                              _showAddClassDialog();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
          
          // Habit option
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value,
                  child: _isExpanded
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _buildSpeedDialOption(
                            'Habit',
                            LucideIcons.target,
                            ThemeProvider.gradientColors[6],
                            () {
                              _toggleExpanded();
                              _showAddHabitDialog();
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
          
          // Main FAB
          FloatingActionButton(
            heroTag: "main_fab",
            onPressed: _toggleExpanded,
            backgroundColor: _isExpanded 
                ? ThemeProvider.gradientColors[1] 
                : ThemeProvider.gradientColors[0],
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isExpanded ? LucideIcons.x : LucideIcons.plus,
                key: ValueKey<bool>(_isExpanded),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      );
    } else if (_currentIndex == 1) {
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

  Widget _buildSpeedDialOption(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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