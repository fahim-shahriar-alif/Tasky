import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Show 7 days with today in the middle (index 3)
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 3)); // 3 days before today
    
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = startDate.add(Duration(days: index));
          final isSelected = _isSameDay(date, selectedDate);
          final isToday = _isToday(date);

          return Flexible(
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                constraints: const BoxConstraints(
                  minWidth: 50,
                  maxWidth: 70,
                ),
                height: 85,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  gradient: isSelected 
                    ? ThemeProvider.getPrimaryGradient()
                    : null,
                  color: isSelected 
                    ? null 
                    : Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF0F0F5),
                  borderRadius: BorderRadius.circular(25), // Pill shape
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: ThemeProvider.gradientColors[0].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        color: isSelected 
                          ? Colors.white
                          : colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        color: isSelected 
                          ? Colors.white.withOpacity(0.9)
                          : colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isToday && !isSelected) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: ThemeProvider.getPrimaryGradient(),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}