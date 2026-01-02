import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/task_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../models/task_category.dart';
import '../models/prayer.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with TickerProviderStateMixin {
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
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.checkSquare),
              text: 'Tasks',
            ),
            Tab(
              icon: Icon(LucideIcons.target),
              text: 'Habits',
            ),
            Tab(
              icon: Icon(LucideIcons.graduationCap),
              text: 'Classes',
            ),
            Tab(
              icon: Icon(LucideIcons.clock),
              text: 'Prayers',
            ),
          ],
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTaskAnalytics(),
              _buildHabitAnalytics(),
              _buildClassAttendanceAnalytics(),
              _buildPrayerAnalytics(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskAnalytics() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        final completedTasks = taskProvider.completedTasks;
        final pendingTasks = taskProvider.pendingTasks;
        final todayTasks = taskProvider.todayTasks;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Tasks',
                      '${tasks.length}',
                      LucideIcons.list,
                      ThemeProvider.gradientColors[4],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Completed',
                      '${completedTasks.length}',
                      LucideIcons.checkCircle,
                      ThemeProvider.gradientColors[7],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Pending',
                      '${pendingTasks.length}',
                      LucideIcons.clock,
                      ThemeProvider.gradientColors[1],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Today',
                      '${todayTasks.length}',
                      LucideIcons.calendar,
                      ThemeProvider.gradientColors[2],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Task Completion Pie Chart
              Container(
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Completion Overview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: tasks.isEmpty
                            ? Center(
                                child: Text(
                                  'No tasks to display',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      gradient: LinearGradient(
                                        colors: [
                                          ThemeProvider.gradientColors[6], // Teal
                                          ThemeProvider.gradientColors[7], // Light Cyan
                                        ],
                                      ),
                                      value: completedTasks.length.toDouble(),
                                      title: '${completedTasks.length}',
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PieChartSectionData(
                                      gradient: LinearGradient(
                                        colors: [
                                          ThemeProvider.gradientColors[1], // Purple
                                          ThemeProvider.gradientColors[2], // Lavender
                                        ],
                                      ),
                                      value: pendingTasks.length.toDouble(),
                                      title: '${pendingTasks.length}',
                                      radius: 70,
                                      titleStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 2,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 50,
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                                    enabled: true,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('Completed', ThemeProvider.gradientColors[6]),
                          const SizedBox(width: 16),
                          _buildLegendItem('Pending', ThemeProvider.gradientColors[1]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Priority Distribution
              Container(
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Priority Distribution',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPriorityBars(tasks),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHabitAnalytics() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.habits;
        final completedToday = habits.where((habit) => 
          habitProvider.isHabitCompletedOnDate(habit.id, DateTime.now())).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Habits',
                      '${habits.length}',
                      LucideIcons.target,
                      ThemeProvider.gradientColors[4],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Today',
                      '$completedToday/${habits.length}',
                      LucideIcons.calendar,
                      ThemeProvider.gradientColors[7],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Habit Streaks
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habit Streaks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      habits.isEmpty
                          ? Center(
                              child: Text(
                                'No habits to display',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : Column(
                              children: habits.map((habit) {
                                final streak = habitProvider.getHabitStreak(habit.id);
                                return ListTile(
                                  leading: Icon(
                                    LucideIcons.flame,
                                    color: streak > 0 ? Colors.orange : Colors.grey,
                                  ),
                                  title: Text(habit.name),
                                  trailing: Text(
                                    '$streak days',
                                    style: TextStyle(
                                      color: streak > 0 ? Colors.orange : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weekly Progress
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Week\'s Progress',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: habits.isEmpty
                            ? Center(
                                child: Text(
                                  'No habits to display',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: habits.length.toDouble() + 1,
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor: (group) => Colors.black87,
                                      tooltipRoundedRadius: 8,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                        return BarTooltipItem(
                                          '${days[group.x.toInt()]}\n${rod.toY.round()} habits',
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text(
                                              days[value.toInt() % 7],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 1,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: _getWeeklyHabitData(habitProvider),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularStatCard(BuildContext context, String title, int value, int total, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = total > 0 ? value / total : 0.0;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
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
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 8,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      '${(percentage * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$value${total > 0 ? '/$total' : ''}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
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
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildPriorityBars(List tasks) {
    final highPriority = tasks.where((task) => task.priority == TaskPriority.high).length;
    final mediumPriority = tasks.where((task) => task.priority == TaskPriority.medium).length;
    final lowPriority = tasks.where((task) => task.priority == TaskPriority.low).length;
    final total = tasks.length;

    if (total == 0) {
      return Center(
        child: Text(
          'No tasks to display',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildPriorityBar('High Priority', highPriority, total, ThemeProvider.gradientColors[0]),
        const SizedBox(height: 8),
        _buildPriorityBar('Medium Priority', mediumPriority, total, ThemeProvider.gradientColors[1]),
        const SizedBox(height: 8),
        _buildPriorityBar('Low Priority', lowPriority, total, ThemeProvider.gradientColors[7]),
      ],
    );
  }

  Widget _buildPriorityBar(String label, int count, int total, Color color) {
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '$count (${(percentage * 100).round()}%)',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color.withOpacity(0.2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _getWeeklyHabitData(HabitProvider habitProvider) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final completedCount = habitProvider.habits.where((habit) =>
        habitProvider.isHabitCompletedOnDate(habit.id, date)).length;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: completedCount.toDouble(),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                ThemeProvider.gradientColors[4], // Blue
                ThemeProvider.gradientColors[5], // Light Blue
              ],
            ),
            width: 20,
            borderRadius: BorderRadius.circular(12),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: habitProvider.habits.length.toDouble(),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  ThemeProvider.gradientColors[4].withOpacity(0.1),
                  ThemeProvider.gradientColors[5].withOpacity(0.05),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildClassAttendanceAnalytics() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // Filter only class tasks (recurring tasks with Class category)
        final classTasks = taskProvider.tasks.where((task) => 
          task.category == TaskCategory.classCategory && task.isRecurring).toList();
        
        if (classTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.graduationCap,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Classes Found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add some classes to track attendance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        // Group classes by title (same class, different instances)
        final classGroups = <String, List<Task>>{};
        for (final task in classTasks) {
          classGroups.putIfAbsent(task.title, () => []).add(task);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Classes',
                      '${classGroups.length}',
                      LucideIcons.graduationCap,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Attended',
                      '${classTasks.where((task) => task.isCompleted).length}',
                      LucideIcons.checkCircle,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Missed',
                      '${classTasks.where((task) => !task.isCompleted && _isClassInPast(task)).length}',
                      LucideIcons.xCircle,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Attendance Rate',
                      '${_calculateAttendanceRate(classTasks)}%',
                      LucideIcons.percent,
                      _getAttendanceColor(_calculateAttendanceRate(classTasks)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Attendance Overview Pie Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Attendance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildAttendancePieChart(classTasks),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('Present', ThemeProvider.gradientColors[7]),
                          const SizedBox(width: 16),
                          _buildLegendItem('Absent', ThemeProvider.gradientColors[0]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Individual Class Attendance
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class-wise Attendance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...classGroups.entries.map((entry) {
                        final className = entry.key;
                        final classInstances = entry.value;
                        final attended = classInstances.where((task) => task.isCompleted).length;
                        final missed = classInstances.where((task) => !task.isCompleted && _isClassInPast(task)).length;
                        final total = attended + missed;
                        final attendanceRate = total > 0 ? (attended / total * 100).round() : 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          className,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Instructor: ${classInstances.first.instructor ?? 'N/A'}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getAttendanceColor(attendanceRate).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getAttendanceColor(attendanceRate),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$attendanceRate%',
                                      style: TextStyle(
                                        color: _getAttendanceColor(attendanceRate),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildAttendanceChip('Present', attended, Colors.green),
                                  const SizedBox(width: 8),
                                  _buildAttendanceChip('Absent', missed, Colors.red),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: total > 0 ? attended / total : 0,
                                backgroundColor: ThemeProvider.gradientColors[0].withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(ThemeProvider.gradientColors[7]),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendancePieChart(List<Task> classTasks) {
    final attended = classTasks.where((task) => task.isCompleted).length;
    final missed = classTasks.where((task) => !task.isCompleted && _isClassInPast(task)).length;

    if (attended == 0 && missed == 0) {
      return Center(
        child: Text(
          'No class data to display',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final sections = <PieChartSectionData>[];
    
    if (attended > 0) {
      sections.add(PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            ThemeProvider.gradientColors[7], // Teal
            ThemeProvider.gradientColors[6], // Light Cyan
          ],
        ),
        value: attended.toDouble(),
        title: '$attended',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
      ));
    }
    
    if (missed > 0) {
      sections.add(PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            ThemeProvider.gradientColors[0], // Pink
            ThemeProvider.gradientColors[1], // Purple
          ],
        ),
        value: missed.toDouble(),
        title: '$missed',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
      ));
    }

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 4,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
      ),
    );
  }

  Widget _buildAttendanceChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _isClassInPast(Task task) {
    if (task.dueDate == null || task.dueTime == null) return false;
    
    final classDateTime = DateTime(
      task.dueDate!.year,
      task.dueDate!.month,
      task.dueDate!.day,
      task.dueTime!.hour,
      task.dueTime!.minute,
    );
    
    return classDateTime.isBefore(DateTime.now());
  }

  Color _getAttendanceColor(int percentage) {
    if (percentage >= 80) return ThemeProvider.gradientColors[7]; // Teal
    if (percentage >= 60) return ThemeProvider.gradientColors[1]; // Purple  
    return ThemeProvider.gradientColors[0]; // Pink
  }

  List<FlSpot> _getWeeklyHabitLineData(HabitProvider habitProvider) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final completedCount = habitProvider.habits.where((habit) =>
        habitProvider.isHabitCompletedOnDate(habit.id, date)).length;
      
      return FlSpot(index.toDouble(), completedCount.toDouble());
    });
  }

  int _calculateAttendanceRate(List<Task> classTasks) {
    final attended = classTasks.where((task) => task.isCompleted).length;
    final missed = classTasks.where((task) => !task.isCompleted && _isClassInPast(task)).length;
    final total = attended + missed;
    
    if (total == 0) return 0;
    return (attended / total * 100).round();
  }

  Widget _buildPrayerAnalytics() {
    return Consumer<PrayerProvider>(
      builder: (context, prayerProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prayer Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Today\'s Prayers',
                      '${prayerProvider.getCompletedCount()}/5',
                      LucideIcons.clock,
                      ThemeProvider.gradientColors[0],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Completion Rate',
                      '${prayerProvider.getCompletionPercentage().round()}%',
                      LucideIcons.target,
                      ThemeProvider.gradientColors[1],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Prayer Completion Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.pieChart,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Today\'s Prayer Status',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildPrayerPieChart(prayerProvider),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Individual Prayer Status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.list,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Prayer Details',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...prayerProvider.todayPrayers.map((prayer) => 
                        _buildPrayerStatusItem(context, prayer)
                      ).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Prayer Statistics
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.barChart3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Prayer Statistics',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPrayerStatsGrid(context, prayerProvider),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Spiritual Progress Card
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.getPrimaryGradient(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.heart,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Spiritual Progress',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getPrayerMotivationalMessage(prayerProvider.getCompletionPercentage()),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: prayerProvider.getCompletionPercentage() / 100,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerPieChart(PrayerProvider prayerProvider) {
    final completed = prayerProvider.getCompletedCount();
    final remaining = 5 - completed;

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: [
          PieChartSectionData(
            color: ThemeProvider.gradientColors[0],
            value: completed.toDouble(),
            title: '$completed',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.grey.withOpacity(0.3),
            value: remaining.toDouble(),
            title: '$remaining',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatusItem(BuildContext context, Prayer prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: prayer.isCompleted 
          ? ThemeProvider.gradientColors[0].withOpacity(0.1)
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: prayer.isCompleted
          ? Border.all(color: ThemeProvider.gradientColors[0].withOpacity(0.3))
          : null,
      ),
      child: Row(
        children: [
          Text(
            prayer.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${prayer.name} (${prayer.arabicName})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Time: ${prayer.time.hour.toString().padLeft(2, '0')}:${prayer.time.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            prayer.isCompleted ? LucideIcons.checkCircle : LucideIcons.circle,
            color: prayer.isCompleted 
              ? ThemeProvider.gradientColors[0]
              : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStatsGrid(BuildContext context, PrayerProvider prayerProvider) {
    final nextPrayer = prayerProvider.getNextPrayer();
    final completedCount = prayerProvider.getCompletedCount();
    final completionRate = prayerProvider.getCompletionPercentage();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPrayerStatItem(
                context,
                'Completed Today',
                '$completedCount',
                LucideIcons.checkCircle,
                ThemeProvider.gradientColors[0],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPrayerStatItem(
                context,
                'Remaining',
                '${5 - completedCount}',
                LucideIcons.clock,
                ThemeProvider.gradientColors[1],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPrayerStatItem(
                context,
                'Completion Rate',
                '${completionRate.round()}%',
                LucideIcons.target,
                ThemeProvider.gradientColors[2],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPrayerStatItem(
                context,
                'Next Prayer',
                nextPrayer?.name ?? 'None',
                LucideIcons.bell,
                ThemeProvider.gradientColors[3],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrayerStatItem(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerMotivationalMessage(double completionRate) {
    if (completionRate == 100) {
      return 'Excellent! You\'ve completed all prayers today. May Allah accept your worship! 🤲';
    } else if (completionRate >= 80) {
      return 'Great progress! You\'re doing well with your prayers. Keep it up! 💪';
    } else if (completionRate >= 60) {
      return 'Good effort! Try to complete the remaining prayers on time. 🕌';
    } else if (completionRate >= 40) {
      return 'You can do better! Remember, prayer is the pillar of faith. 📿';
    } else if (completionRate > 0) {
      return 'Every prayer counts! Try to catch up with the remaining prayers. 🌙';
    } else {
      return 'Start your spiritual journey! Begin with the next prayer time. ✨';
    }
  }
}