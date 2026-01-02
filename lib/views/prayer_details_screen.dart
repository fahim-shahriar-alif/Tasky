import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/prayer_provider.dart';
import '../providers/theme_provider.dart';
import '../models/prayer.dart';
import '../models/bangladesh_district.dart';

class PrayerDetailsScreen extends StatelessWidget {
  const PrayerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PrayerProvider>(
        builder: (context, prayerProvider, child) {
          if (prayerProvider.isLoading) {
            return _buildLoadingScreen(context);
          }

          if (prayerProvider.error != null) {
            return _buildErrorScreen(context, prayerProvider);
          }

          final prayers = prayerProvider.todayPrayers;
          if (prayers.isEmpty) {
            return _buildEmptyScreen(context);
          }

          return _buildPrayerDetailsContent(context, prayerProvider, prayers);
        },
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeProvider.getPrimaryGradient(),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, PrayerProvider prayerProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeProvider.getPrimaryGradient(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Prayer Times',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.alertCircle,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Prayer Times',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        prayerProvider.error ?? 'Unknown error',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => prayerProvider.fetchTodayPrayers(),
                      icon: const Icon(LucideIcons.refreshCw),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ThemeProvider.gradientColors[0],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeProvider.getPrimaryGradient(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Prayer Times',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.clock,
                      color: Colors.white,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Prayer Times Available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerDetailsContent(BuildContext context, PrayerProvider prayerProvider, List<Prayer> prayers) {
    final nextPrayer = prayerProvider.getNextPrayer();
    final completionPercentage = prayerProvider.getCompletionPercentage();
    final completedCount = prayerProvider.getCompletedCount();

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeProvider.getPrimaryGradient(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🕌 Prayer Times',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (nextPrayer != null)
                          Text(
                            'Next: ${nextPrayer.name} in ${nextPrayer.timeUntilFormatted}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => prayerProvider.fetchTodayPrayers(),
                    icon: const Icon(
                      LucideIcons.refreshCw,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Selector
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Location:',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<BangladeshDistrict>(
                                  value: prayerProvider.selectedDistrict,
                                  isExpanded: true,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  items: prayerProvider.getAllDistricts().map((district) {
                                    return DropdownMenuItem<BangladeshDistrict>(
                                      value: district,
                                      child: Text(
                                        '${district.name}, ${district.division}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (BangladeshDistrict? newDistrict) {
                                    if (newDistrict != null) {
                                      prayerProvider.changeDistrict(newDistrict);
                                    }
                                  },
                                  dropdownColor: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '🇧🇩',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Progress indicator
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today\'s Progress',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: completionPercentage / 100,
                                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '$completedCount/5',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Prayer list
                      Text(
                        'Prayer Schedule',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...prayers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final prayer = entry.value;
                        return _buildPrayerItem(context, prayer, index, prayerProvider);
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerItem(BuildContext context, Prayer prayer, int index, PrayerProvider prayerProvider) {
    final timeFormat = DateFormat('h:mm a');
    final isNext = prayerProvider.getNextPrayer()?.name == prayer.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => prayerProvider.togglePrayerCompletion(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: prayer.isCompleted
                ? LinearGradient(
                    colors: [
                      ThemeProvider.gradientColors[0].withOpacity(0.1),
                      ThemeProvider.gradientColors[1].withOpacity(0.05),
                    ],
                  )
                : isNext
                    ? LinearGradient(
                        colors: [
                          ThemeProvider.gradientColors[2].withOpacity(0.1),
                          ThemeProvider.gradientColors[3].withOpacity(0.05),
                        ],
                      )
                    : null,
            color: !prayer.isCompleted && !isNext
                ? Theme.of(context).cardColor
                : null,
            borderRadius: BorderRadius.circular(16),
            border: isNext
                ? Border.all(
                    color: ThemeProvider.gradientColors[2].withOpacity(0.3),
                    width: 2,
                  )
                : prayer.isCompleted
                    ? Border.all(
                        color: ThemeProvider.gradientColors[0].withOpacity(0.3),
                        width: 1,
                      )
                    : null,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Prayer completion checkbox
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: prayer.isCompleted
                      ? ThemeProvider.getPrimaryGradient()
                      : null,
                  border: !prayer.isCompleted
                      ? Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 2,
                        )
                      : null,
                ),
                child: prayer.isCompleted
                    ? const Icon(
                        LucideIcons.check,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Prayer emoji and names
              Text(
                prayer.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          prayer.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: prayer.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          prayer.arabicName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (isNext && !prayer.hasPassed)
                      Text(
                        'In ${prayer.timeUntilFormatted}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else if (prayer.hasPassed && !prayer.isCompleted)
                      Text(
                        'Missed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else if (prayer.isCompleted)
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ThemeProvider.gradientColors[0],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

              // Prayer time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeFormat.format(prayer.time),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isNext
                          ? Theme.of(context).colorScheme.primary
                          : prayer.hasPassed
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (isNext && !prayer.hasPassed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NEXT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}