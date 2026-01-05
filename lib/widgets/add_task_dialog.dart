import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/task_category.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task; // If provided, we're editing
  final Function({
    required String title,
    required TaskPriority priority,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    String? category,
    bool hasReminder,
    DateTime? reminderDateTime,
    bool isRecurring,
    List<int>? recurringDays,
    DateTime? recurringEndDate,
    String? location,
    String? instructor,
    double? duration,
  }) onSave;

  const AddTaskDialog({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  String? _selectedCategory;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedDueTime;
  bool _hasReminder = false;
  DateTime? _reminderDateTime;
  bool _isRecurring = false;
  List<int> _selectedDays = [];
  DateTime? _recurringEndDate;
  final _formKey = GlobalKey<FormState>();

  final List<String> _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedCategory = widget.task?.category;
    _selectedDueDate = widget.task?.dueDate;
    _selectedDueTime = widget.task?.dueTime;
    _hasReminder = widget.task?.hasReminder ?? false;
    _reminderDateTime = widget.task?.reminderDateTime;
    _isRecurring = widget.task?.isRecurring ?? false;
    _selectedDays = widget.task?.recurringDays ?? [];
    _recurringEndDate = widget.task?.recurringEndDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.plus,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Task' : 'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Task Title *',
                          hintText: 'Enter task description',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.edit3),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a task title';
                          }
                          return null;
                        },
                        autofocus: true,
                        maxLines: 2,
                        minLines: 1,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Add more details about this task',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.fileText),
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Priority Selection
                      Text(
                        'Priority',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildPrioritySelector(),
                      
                      const SizedBox(height: 16),
                      
                      // Due Date and Time
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _selectDueDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Due Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(LucideIcons.calendar),
                                ),
                                child: Text(
                                  _selectedDueDate != null
                                      ? DateFormat('MMM d, y').format(_selectedDueDate!)
                                      : 'Select date',
                                  style: TextStyle(
                                    color: _selectedDueDate != null
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: _selectedDueDate != null ? _selectDueTime : null,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Due Time',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(LucideIcons.clock),
                                  enabled: _selectedDueDate != null,
                                ),
                                child: Text(
                                  _selectedDueTime != null
                                      ? _selectedDueTime!.format(context)
                                      : 'Select time',
                                  style: TextStyle(
                                    color: _selectedDueTime != null && _selectedDueDate != null
                                        ? Theme.of(context).colorScheme.onSurface
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.tag),
                        ),
                        hint: const Text('Select category'),
                        items: TaskCategory.allCategories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Row(
                              children: [
                                Text(
                                  TaskCategory.getIcon(category),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(category),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Recurring Task Toggle
                      Card(
                        elevation: 4,
                        shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                        child: SwitchListTile(
                          title: const Text('Recurring Task'),
                          subtitle: Text(_isRecurring 
                            ? 'Repeats on selected days' 
                            : 'One-time task'),
                          value: _isRecurring,
                          onChanged: (value) {
                            setState(() {
                              _isRecurring = value;
                              if (!value) {
                                _selectedDays.clear();
                                _recurringEndDate = null;
                              }
                            });
                          },
                          secondary: const Icon(LucideIcons.repeat),
                        ),
                      ),

                      if (_isRecurring) ...[
                        const SizedBox(height: 16),
                        
                        // Days Selection
                        Text(
                          'Select Days',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (index) {
                            final dayNumber = index + 6; // 6=Saturday, 7=Sunday, 1=Monday, etc.
                            final adjustedDayNumber = dayNumber > 7 ? dayNumber - 7 : dayNumber;
                            final isSelected = _selectedDays.contains(adjustedDayNumber);
                            return FilterChip(
                              label: Text(_dayNames[index]),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDays.add(adjustedDayNumber);
                                  } else {
                                    _selectedDays.remove(adjustedDayNumber);
                                  }
                                  _selectedDays.sort();
                                });
                              },
                            );
                          }),
                        ),

                        const SizedBox(height: 16),

                        // Recurring End Date
                        InkWell(
                          onTap: _selectRecurringEndDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date (Optional)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(LucideIcons.calendarX),
                            ),
                            child: Text(
                              _recurringEndDate != null
                                  ? DateFormat('MMM d, y').format(_recurringEndDate!)
                                  : 'Select end date',
                              style: TextStyle(
                                color: _recurringEndDate != null
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                      
                      // Reminder Toggle
                      Card(
                        elevation: 4,
                        shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                        child: SwitchListTile(
                          title: const Text('Set Reminder'),
                          subtitle: _hasReminder && _reminderDateTime != null
                              ? Text(DateFormat('MMM d, y at h:mm a').format(_reminderDateTime!))
                              : const Text('Get notified about this task'),
                          value: _hasReminder,
                          onChanged: (value) {
                            setState(() {
                              _hasReminder = value;
                              if (value && _selectedDueDate != null) {
                                _reminderDateTime = _selectedDueDate!.subtract(const Duration(hours: 1));
                              }
                            });
                          },
                          secondary: const Icon(LucideIcons.bell),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _saveTask,
                    child: Text(isEditing ? 'Update Task' : 'Add Task'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: TaskPriority.values.map((priority) {
        final isSelected = _selectedPriority == priority;
        Color priorityColor;
        IconData priorityIcon;
        
        switch (priority) {
          case TaskPriority.high:
            priorityColor = Colors.red;
            priorityIcon = LucideIcons.alertTriangle;
            break;
          case TaskPriority.medium:
            priorityColor = Colors.orange;
            priorityIcon = LucideIcons.minus;
            break;
          case TaskPriority.low:
            priorityColor = Colors.green;
            priorityIcon = LucideIcons.arrowDown;
            break;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPriority = priority),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected 
                  ? priorityColor.withOpacity(0.1) 
                  : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                    ? priorityColor 
                    : Theme.of(context).colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    priorityIcon,
                    color: isSelected 
                      ? priorityColor 
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPriorityText(priority),
                    style: TextStyle(
                      color: isSelected 
                        ? priorityColor 
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDueDate = date;
        // Reset time if date changes
        if (_selectedDueTime == null) {
          _selectedDueTime = const TimeOfDay(hour: 9, minute: 0);
        }
      });
    }
  }

  Future<void> _selectDueTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (time != null) {
      setState(() => _selectedDueTime = time);
    }
  }

  Future<void> _selectRecurringEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _recurringEndDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1095)), // 3 years
    );
    
    if (date != null) {
      setState(() => _recurringEndDate = date);
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Validate recurring task requirements
      if (_isRecurring && _selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day for recurring task')),
        );
        return;
      }
      
      widget.onSave(
        title: _titleController.text.trim(),
        priority: _selectedPriority,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        dueDate: _selectedDueDate,
        dueTime: _selectedDueTime,
        category: _selectedCategory,
        hasReminder: _hasReminder,
        reminderDateTime: _reminderDateTime,
        isRecurring: _isRecurring,
        recurringDays: _isRecurring ? _selectedDays : null,
        recurringEndDate: _recurringEndDate,
        location: null,
        instructor: null,
        duration: null,
      );
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }
}