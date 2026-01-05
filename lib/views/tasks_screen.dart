import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/class_card.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/add_class_dialog.dart';
import '../models/task_category.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final todayTasks = taskProvider.todayTasks;
        final allTasks = taskProvider.tasks;
        final completedTasks = taskProvider.completedTasks;
        final pendingTasks = taskProvider.pendingTasks;

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
                            LucideIcons.checkSquare,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Task Overview',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(context, 'Today', '${todayTasks.length}', Colors.blue),
                          _buildStatColumn(context, 'Total', '${allTasks.length}', Colors.purple),
                          _buildStatColumn(context, 'Completed', '${completedTasks.length}', Colors.green),
                          _buildStatColumn(context, 'Pending', '${pendingTasks.length}', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.calendar, size: 16),
                      const SizedBox(width: 4),
                      Text('Today (${todayTasks.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.list, size: 16),
                      const SizedBox(width: 4),
                      Text('All (${allTasks.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.checkCircle, size: 16),
                      const SizedBox(width: 4),
                      Text('Done (${completedTasks.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.clock, size: 16),
                      const SizedBox(width: 4),
                      Text('Pending (${pendingTasks.length})'),
                    ],
                  ),
                ),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(todayTasks, taskProvider, 'No tasks for today'),
                  _buildTaskList(allTasks, taskProvider, 'No tasks yet'),
                  _buildTaskList(completedTasks, taskProvider, 'No completed tasks'),
                  _buildTaskList(pendingTasks, taskProvider, 'No pending tasks'),
                ],
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
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks, TaskProvider taskProvider, String emptyMessage) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.checkSquare,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first task',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        
        // Check if this is a class task
        final isClass = task.category == TaskCategory.classCategory && task.isRecurring;
        
        if (isClass) {
          return ClassCard(
            task: task,
            onToggleAttendance: () => taskProvider.toggleTaskCompletion(task.id),
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
    );
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
          if (context.mounted) {
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
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task added successfully')),
            );
          }
        },
      ),
    );
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
    // Check if this is a class (has class category and is recurring)
    final isClass = task.category == TaskCategory.classCategory && task.isRecurring;
    
    if (isClass) {
      showDialog(
        context: context,
        builder: (context) => AddClassDialog(
          task: task,
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
            await taskProvider.updateTask(
              taskId: task.id,
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
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Class updated')),
              );
            }
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AddTaskDialog(
          task: task,
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
            await taskProvider.updateTask(
              taskId: task.id,
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
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task updated')),
              );
            }
          },
        ),
      );
    }
  }
}