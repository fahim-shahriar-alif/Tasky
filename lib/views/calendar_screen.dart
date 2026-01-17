import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/prayer_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/class_card.dart';
import '../models/task_category.dart';
import '../widgets/prayer_times_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    
    // Refresh prayer times when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerProvider>(context, listen: false).refreshIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<TaskProvider, HabitProvider, PrayerProvider>(
      builder: (context, taskProvider, habitProvider, prayerProvider, child) {
        final selectedDayTasks = _getTasksForDay(_selectedDay, taskProvider.tasks);
        final selectedDayHabits = habitProvider.habits;
        final selectedDayHabitLogs = habitProvider.habitLogs
            .where((log) => log.isForDate(_selectedDay))
            .toList();

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Welcome Section
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu Alaikum! 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'May your day be blessed and productive',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Prayer Times Card
                const PrayerTimesCard(),
                // Calendar Widget with Modern Styling
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [
                              const Color(0xFF2A2A2A),
                              const Color(0xFF1E1E1E),
                            ]
                          : [
                              Colors.white,
                              const Color(0xFFFAFAFA),
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TableCalendar<Task>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      eventLoader: (day) => _getTasksForDay(day, taskProvider.tasks),
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      weekendDays: const [DateTime.friday, DateTime.saturday],
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return _buildModernDateCell(context, day, false, false);
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return _buildModernDateCell(context, day, true, false);
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return _buildModernDateCell(context, day, false, true);
                        },
                        outsideBuilder: (context, day, focusedDay) {
                          return _buildModernDateCell(context, day, false, false, isOutside: true);
                        },
                        // Completely remove markerBuilder to disable all markers
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: true,
                        weekendTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                        ),
                        holidayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                        ),
                        // Hide default decorations since we're using custom builders
                        selectedDecoration: const BoxDecoration(),
                        todayDecoration: const BoxDecoration(),
                        defaultDecoration: const BoxDecoration(),
                        outsideDecoration: const BoxDecoration(),
                        markerDecoration: const BoxDecoration(),
                        // Disable all markers
                        markersMaxCount: 0,
                        canMarkersOverflow: false,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        titleTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          gradient: ThemeProvider.getSecondaryGradient(),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeProvider.gradientColors[4].withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        formatButtonTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        leftChevronIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            LucideIcons.chevronLeft,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        rightChevronIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            LucideIcons.chevronRight,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        weekendStyle: TextStyle(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                // Selected Day Info
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 8,
                    shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('EEEE, MMMM d, y').format(_selectedDay),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildStatChip(
                                context,
                                LucideIcons.checkSquare,
                                '${selectedDayTasks.length} Tasks',
                                Colors.blue,
                              ),
                              _buildStatChip(
                                context,
                                LucideIcons.target,
                                '${selectedDayHabitLogs.where((log) => log.isCompleted).length}/${selectedDayHabits.length} Habits',
                                Colors.green,
                              ),
                              _buildStatChip(
                                context,
                                LucideIcons.checkCircle,
                                '${selectedDayTasks.where((task) => task.isCompleted).length} Done',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tasks for Selected Day
                Container(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  margin: const EdgeInsets.all(16),
                  child: selectedDayTasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.calendar,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks for this day',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Select a different date or add new tasks',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: selectedDayTasks.length,
                          itemBuilder: (context, index) {
                            final task = selectedDayTasks[index];
                            
                            // Check if this is a class task
                            final isClass = task.category == TaskCategory.classCategory && task.isRecurring;
                            
                            if (isClass) {
                              return ClassCard(
                                task: task,
                                selectedDate: _selectedDay,
                                onToggleAttendance: () => taskProvider.toggleTaskCompletionForDate(task.id, _selectedDay),
                                onDelete: () => _showDeleteConfirmation(context, task, taskProvider),
                                onEdit: () => _showEditTaskDialog(context, task, taskProvider),
                              );
                            } else {
                              return TaskCard(
                                task: task,
                                onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                                onDelete: () => _showDeleteConfirmation(context, task, taskProvider),
                                onEdit: () => _showEditTaskDialog(context, task, taskProvider),
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDateCell(BuildContext context, DateTime day, bool isSelected, bool isToday, {bool isOutside = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEvents = _getTasksForDay(day, Provider.of<TaskProvider>(context, listen: false).tasks).isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        gradient: isSelected 
          ? ThemeProvider.getPrimaryGradient()
          : null,
        color: isSelected 
          ? null 
          : isOutside 
            ? Colors.transparent
            : Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : const Color(0xFFF0F0F5),
        borderRadius: BorderRadius.circular(20), // Pill shape
        boxShadow: isSelected ? [
          BoxShadow(
            color: ThemeProvider.gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : isOutside ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: isSelected 
                  ? Colors.white
                  : isOutside 
                    ? colorScheme.onSurface.withOpacity(0.3)
                    : isToday
                      ? ThemeProvider.gradientColors[0]
                      : colorScheme.onSurface,
                fontSize: 16,
                fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (hasEvents && !isSelected)
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.getSecondaryGradient(),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          if (isToday && !isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: ThemeProvider.getPrimaryGradient(),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Task> _getTasksForDay(DateTime day, List<Task> allTasks) {
    return allTasks.where((task) {
      // For recurring tasks, check if they should occur on this day
      if (task.isRecurring) {
        return task.shouldOccurOnDate(day);
      }
      
      // For non-recurring tasks, check creation date or due date
      final createdOnDay = task.createdAt.year == day.year &&
          task.createdAt.month == day.month &&
          task.createdAt.day == day.day;
      
      final dueOnDay = task.dueDate != null &&
          task.dueDate!.year == day.year &&
          task.dueDate!.month == day.month &&
          task.dueDate!.day == day.day;
      
      return createdOnDay || dueOnDay;
    }).toList();
  }

  void _showDeleteConfirmation(BuildContext context, Task task, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              taskProvider.deleteTask(task.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, TaskProvider taskProvider) {
    // This would open the edit dialog - implementation similar to tasks_tab.dart
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality - navigate to Tasks tab')),
    );
  }
}