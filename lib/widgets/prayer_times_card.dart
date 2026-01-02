import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/prayer_provider.dart';
import '../providers/theme_provider.dart';
import '../models/prayer.dart';
import '../views/prayer_details_screen.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, prayerProvider, child) {
        // Show loading card only if there are no prayers and it's loading
        if (prayerProvider.isLoading && prayerProvider.todayPrayers.isEmpty) {
          return _buildLoadingCard(context);
        }

        if (prayerProvider.error != null && prayerProvider.todayPrayers.isEmpty) {
          return _buildErrorCard(context, prayerProvider);
        }

        final prayers = prayerProvider.todayPrayers;
        if (prayers.isEmpty && !prayerProvider.isLoading) {
          return _buildEmptyCard(context);
        }

        // Always show the compact timeline card, even during loading if we have prayers
        return _buildCompactTimelineCard(context, prayerProvider, prayers);
      },
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prayer Times',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading prayer times...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, PrayerProvider prayerProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prayer Times',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                prayerProvider.error ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => prayerProvider.fetchTodayPrayers(),
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prayer Times',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'No prayer times available',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTimelineCard(BuildContext context, PrayerProvider prayerProvider, List<Prayer> prayers) {
    final nextPrayer = prayerProvider.getNextPrayer();
    final completedCount = prayerProvider.getCompletedCount();
    final currentPrayerIndex = _getCurrentPrayerIndex(prayers);
    final dayProgress = _calculateDayProgress(prayers);
    final isLoading = prayerProvider.isLoading;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrayerDetailsScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: ThemeProvider.getPrimaryGradient(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LucideIcons.clock,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '🕌 Prayer Times',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Show loading indicator or completion count
                      if (isLoading)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      else
                        Text(
                          '$completedCount/5',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Next prayer info (compact) - hide during loading
                  if (!isLoading) ...[
                    if (nextPrayer != null) ...[
                      Row(
                        children: [
                          Text(
                            nextPrayer.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Next: ${nextPrayer.name} in ${nextPrayer.timeUntilFormatted}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('h:mm a').format(nextPrayer.time),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          const Text('✨', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'All prayers completed! 🤲',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ThemeProvider.gradientColors[6],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Compact Timeline
                    _buildCompactTimeline(context, prayers, currentPrayerIndex, dayProgress),

                    const SizedBox(height: 8),
                  ] else ...[
                    // Loading state content
                    const SizedBox(height: 12),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Refreshing prayer times...',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Show simplified timeline during loading
                          if (prayers.isNotEmpty)
                            _buildCompactTimeline(context, prayers, currentPrayerIndex, dayProgress),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Tap to view details
                  Center(
                    child: Text(
                      'Tap for details',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTimeline(BuildContext context, List<Prayer> prayers, int currentIndex, double dayProgress) {
    return Column(
      children: [
        // Timeline dots and line
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              // Background line
              Positioned(
                top: 15,
                left: 15,
                right: 15,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              // Progress line
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 92) * dayProgress,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: ThemeProvider.getPrimaryGradient(),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              // Prayer dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: prayers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final prayer = entry.value;
                  final isPassed = prayer.hasPassed;
                  final isCompleted = prayer.isCompleted;
                  final isCurrent = index == currentIndex;

                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isCurrent
                                  ? LinearGradient(
                                      colors: [
                                        ThemeProvider.gradientColors[1],
                                        ThemeProvider.gradientColors[2],
                                      ],
                                    )
                                  : null,
                              color: !isCompleted && !isCurrent
                                  ? isPassed
                                      ? Theme.of(context).colorScheme.surfaceVariant
                                      : Theme.of(context).colorScheme.surface
                                  : isCompleted
                                      ? Theme.of(context).colorScheme.surfaceVariant
                                      : null,
                              border: (!isCompleted && !isCurrent) || isCompleted
                                  ? Border.all(
                                      color: Theme.of(context).colorScheme.outline,
                                      width: 1.5,
                                    )
                                  : null,
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: ThemeProvider.gradientColors[1].withOpacity(0.3),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                prayer.emoji,
                                style: TextStyle(
                                  fontSize: isCurrent ? 14 : 12,
                                ),
                              ),
                            ),
                          ),
                          // Completed prayer overlay (green circle)
                          if (isCompleted)
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.6),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  LucideIcons.check,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                            ),
                          // Missed prayer overlay (light red circle)
                          if (isPassed && !isCompleted && !isCurrent)
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.6),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  prayer.emoji,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Prayer names (smaller)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: prayers.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            final isCurrent = index == currentIndex;

            return SizedBox(
              width: 30,
              child: Text(
                prayer.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w400,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  int _getCurrentPrayerIndex(List<Prayer> prayers) {
    final now = DateTime.now();
    
    for (int i = 0; i < prayers.length; i++) {
      if (!prayers[i].hasPassed) {
        return i;
      }
    }
    
    return prayers.length - 1; // All prayers have passed
  }

  double _calculateDayProgress(List<Prayer> prayers) {
    if (prayers.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final firstPrayer = prayers.first.time;
    final lastPrayer = prayers.last.time;
    
    if (now.isBefore(firstPrayer)) return 0.0;
    if (now.isAfter(lastPrayer)) return 1.0;
    
    final totalDuration = lastPrayer.difference(firstPrayer).inMinutes;
    final elapsedDuration = now.difference(firstPrayer).inMinutes;
    
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }
}