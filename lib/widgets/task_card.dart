import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/task.dart';
import '../models/task_category.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = const Color(0xFFFF6B9D); // Soft Pink
        break;
      case TaskPriority.medium:
        priorityColor = const Color(0xFF8B5FBF); // Purple
        break;
      case TaskPriority.low:
        priorityColor = const Color(0xFF00C9A7); // Teal
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main task row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modern checkbox with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: task.isCompleted 
                          ? priorityColor 
                          : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: task.isCompleted 
                            ? priorityColor 
                            : colorScheme.outline.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: task.isCompleted
                          ? const Icon(
                              LucideIcons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with modern typography
                          Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              color: task.isCompleted 
                                ? colorScheme.onSurfaceVariant 
                                : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: -0.2,
                            ),
                          ),
                          
                          // Description with better spacing
                          if (task.description != null && task.description!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              task.description!,
                              style: TextStyle(
                                color: task.isCompleted 
                                  ? colorScheme.onSurfaceVariant.withOpacity(0.7)
                                  : colorScheme.onSurfaceVariant,
                                fontSize: 14,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          
                          const SizedBox(height: 12),
                          
                          // Modern tags with glassmorphism
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              // Priority chip with gradient
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      priorityColor.withOpacity(0.1),
                                      priorityColor.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: priorityColor.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  task.priorityText,
                                  style: TextStyle(
                                    color: priorityColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              
                              // Category chip
                              if (task.category != null && task.category!.isNotEmpty)
                                _buildModernChip(
                                  context,
                                  '${TaskCategory.getIcon(task.category!)} ${task.category!}',
                                  _getCategoryColor(task.category!),
                                ),
                              
                              // Due date chip
                              if (task.dueDate != null)
                                _buildModernChip(
                                  context,
                                  task.formattedDueDateTime ?? '',
                                  task.isOverdue 
                                    ? const Color(0xFFEF4444)
                                    : task.isDueToday
                                      ? const Color(0xFFF59E0B)
                                      : colorScheme.primary,
                                  icon: LucideIcons.calendar,
                                ),
                              
                              // Duration chip
                              if (task.duration != null)
                                _buildModernChip(
                                  context,
                                  task.formattedDuration,
                                  const Color(0xFF6366F1),
                                  icon: LucideIcons.clock,
                                ),

                              // Location chip
                              if (task.location != null && task.location!.isNotEmpty)
                                _buildModernChip(
                                  context,
                                  task.location!,
                                  const Color(0xFF06B6D4),
                                  icon: LucideIcons.mapPin,
                                ),

                              // Instructor chip
                              if (task.instructor != null && task.instructor!.isNotEmpty)
                                _buildModernChip(
                                  context,
                                  task.instructor!,
                                  const Color(0xFF8B5CF6),
                                  icon: LucideIcons.user,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Modern menu button
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit();
                              break;
                            case 'delete':
                              onDelete();
                              break;
                          }
                        },
                        icon: Icon(
                          LucideIcons.moreVertical,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(LucideIcons.edit, size: 16, color: colorScheme.primary),
                                const SizedBox(width: 12),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                                const SizedBox(width: 12),
                                const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernChip(BuildContext context, String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colorString = TaskCategory.getColor(category);
    return Color(int.parse(colorString.substring(1, 7), radix: 16) + 0xFF000000);
  }
}