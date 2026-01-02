import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/task_category.dart';

class AddClassDialog extends StatefulWidget {
  final Task? task; // If provided, we're editing
  final Function({
    required String title,
    required TaskPriority priority,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    TimeOfDay? endTime,
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

  const AddClassDialog({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _instructorController;
  late TaskPriority _selectedPriority;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  bool _hasReminder = false;
  DateTime? _reminderDateTime;
  List<int> _selectedDays = [];
  DateTime? _semesterEndDate;
  final _formKey = GlobalKey<FormState>();

  final List<String> _dayNames = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _locationController = TextEditingController(text: widget.task?.location ?? '');
    _instructorController = TextEditingController(text: widget.task?.instructor ?? '');
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedStartTime = widget.task?.dueTime ?? const TimeOfDay(hour: 9, minute: 0);
    _selectedEndTime = widget.task?.endTime ?? const TimeOfDay(hour: 10, minute: 30);
    _hasReminder = widget.task?.hasReminder ?? false;
    _reminderDateTime = widget.task?.reminderDateTime;
    _selectedDays = widget.task?.recurringDays ?? [];
    _semesterEndDate = widget.task?.recurringEndDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _instructorController.dispose();
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
                color: Colors.purple.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '🎓',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Edit Class' : 'Add New Class',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.purple,
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
                      // Class Name Field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Class Name *',
                          hintText: 'e.g., Database Systems, Calculus I',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.bookOpen),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a class name';
                          }
                          return null;
                        },
                        autofocus: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Instructor Field
                      TextFormField(
                        controller: _instructorController,
                        decoration: const InputDecoration(
                          labelText: 'Instructor/Professor *',
                          hintText: 'Prof. Smith, Dr. Johnson',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.user),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter instructor name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Location Field
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          hintText: 'Room 101, Building A',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.mapPin),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter location';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Class Time Row (Start and End Time)
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _selectStartTime,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Time *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(LucideIcons.clock),
                                ),
                                child: Text(
                                  _selectedStartTime != null
                                      ? _selectedStartTime!.format(context)
                                      : 'Select start time',
                                  style: TextStyle(
                                    color: _selectedStartTime != null
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
                              onTap: _selectEndTime,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Time *',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(LucideIcons.clock3),
                                ),
                                child: Text(
                                  _selectedEndTime != null
                                      ? _selectedEndTime!.format(context)
                                      : 'Select end time',
                                  style: TextStyle(
                                    color: _selectedEndTime != null
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
                      
                      // Days Selection
                      Text(
                        'Class Days *',
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
                            selectedColor: Colors.purple.withOpacity(0.2),
                            checkmarkColor: Colors.purple,
                          );
                        }),
                      ),

                      const SizedBox(height: 16),

                      // Description Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Course Description',
                          hintText: 'Course code, additional notes',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(LucideIcons.fileText),
                        ),
                        maxLines: 2,
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

                      // Semester End Date
                      InkWell(
                        onTap: _selectSemesterEndDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Semester End Date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(LucideIcons.calendarX),
                          ),
                          child: Text(
                            _semesterEndDate != null
                                ? DateFormat('MMM d, y').format(_semesterEndDate!)
                                : 'Select semester end date',
                            style: TextStyle(
                              color: _semesterEndDate != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      
                      // Reminder Toggle
                      Card(
                        child: SwitchListTile(
                          title: const Text('Class Reminder'),
                          subtitle: _hasReminder && _reminderDateTime != null
                              ? Text(DateFormat('MMM d, y at h:mm a').format(_reminderDateTime!))
                              : const Text('Get notified before class starts'),
                          value: _hasReminder,
                          onChanged: (value) {
                            setState(() {
                              _hasReminder = value;
                              if (value && _selectedStartTime != null) {
                                final now = DateTime.now();
                                final classDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  _selectedStartTime!.hour,
                                  _selectedStartTime!.minute,
                                );
                                _reminderDateTime = classDateTime.subtract(const Duration(minutes: 15));
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
                color: Colors.purple.withOpacity(0.05),
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
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: _saveClass,
                    child: Text(isEditing ? 'Update Class' : 'Add Class'),
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

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (time != null) {
      setState(() {
        _selectedStartTime = time;
        // Auto-set end time to 1.5 hours later if not already set
        if (_selectedEndTime == null) {
          final endHour = time.hour + 1;
          final endMinute = time.minute + 30;
          if (endMinute >= 60) {
            _selectedEndTime = TimeOfDay(hour: endHour + 1, minute: endMinute - 60);
          } else {
            _selectedEndTime = TimeOfDay(hour: endHour, minute: endMinute);
          }
        }
      });
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ?? const TimeOfDay(hour: 10, minute: 30),
    );
    
    if (time != null) {
      setState(() => _selectedEndTime = time);
    }
  }

  Future<void> _selectSemesterEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _semesterEndDate ?? DateTime.now().add(const Duration(days: 120)), // ~4 months
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() => _semesterEndDate = date);
    }
  }

  void _saveClass() {
    if (_formKey.currentState!.validate()) {
      // Validate class-specific requirements
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one class day')),
        );
        return;
      }

      if (_selectedStartTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select class start time')),
        );
        return;
      }

      if (_selectedEndTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select class end time')),
        );
        return;
      }

      // Calculate duration from start and end times
      final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
      final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
      final durationMinutes = endMinutes - startMinutes;
      
      if (durationMinutes <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final duration = durationMinutes / 60.0; // Convert to hours
      
      widget.onSave(
        title: _titleController.text.trim(),
        priority: _selectedPriority,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        dueDate: null, // Classes don't have due dates
        dueTime: _selectedStartTime,
        endTime: _selectedEndTime,
        category: TaskCategory.classCategory, // Always set to Class
        hasReminder: _hasReminder,
        reminderDateTime: _reminderDateTime,
        isRecurring: true, // Classes are always recurring
        recurringDays: _selectedDays,
        recurringEndDate: _semesterEndDate,
        location: _locationController.text.trim(),
        instructor: _instructorController.text.trim(),
        duration: duration,
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