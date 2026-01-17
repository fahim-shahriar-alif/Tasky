import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/date_picker_row.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        if (habitProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final habits = habitProvider.habitsForSelectedDate;
        final selectedDate = habitProvider.selectedDate;
        final completedToday = habits.where((habit) => 
          habitProvider.isHabitCompletedOnDate(habit.id, selectedDate)).length;

        return Column(
          children: [
            // Progress Card
            Container(
              margin: const EdgeInsets.all(16),
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
                            LucideIcons.target,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Habit Tracker',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        DateFormat('EEEE, MMMM d, y').format(selectedDate),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1))))
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'You can track habits for past dates',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(context, 'Total Habits', '${habits.length}', Colors.blue),
                          _buildStatColumn(context, 'Completed Today', '$completedToday', Colors.green),
                          _buildStatColumn(context, 'Completion Rate', 
                            habits.isEmpty ? '0%' : '${((completedToday / habits.length) * 100).round()}%', 
                            Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DatePickerRow(
                        selectedDate: selectedDate,
                        onDateSelected: habitProvider.setSelectedDate,
                        datesWithEvents: _getDatesWithHabits(habitProvider),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Habits List
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.target,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first habit',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        final isCompleted = habitProvider.isHabitCompletedOnDate(
                          habit.id,
                          selectedDate,
                        );

                        return HabitCard(
                          habit: habit,
                          isCompleted: isCompleted,
                          selectedDate: selectedDate,
                          onToggle: () => habitProvider.toggleHabitCompletion(habit.id),
                          onDelete: () => _showDeleteConfirmation(context, habit, habitProvider),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, habit, HabitProvider habitProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"? This will also delete all tracking data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              habitProvider.deleteHabit(habit.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Habit deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getDatesWithHabits(HabitProvider habitProvider) {
    final List<DateTime> datesWithHabits = [];
    final now = DateTime.now();
    
    // Check the past 30 days and next 7 days for completed habit logs
    for (int i = -30; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      final hasCompletedHabitsOnDate = habitProvider.habitLogs.any((log) => 
        log.isCompleted &&
        log.date.year == date.year &&
        log.date.month == date.month &&
        log.date.day == date.day
      );
      
      if (hasCompletedHabitsOnDate) {
        datesWithHabits.add(date);
      }
    }
    
    return datesWithHabits;
  }
}