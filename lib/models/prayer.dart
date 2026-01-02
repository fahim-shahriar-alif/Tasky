import 'package:hive/hive.dart';

part 'prayer.g.dart';

@HiveType(typeId: 4)
class Prayer extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String arabicName;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  final DateTime date;

  Prayer({
    required this.name,
    required this.arabicName,
    required this.time,
    this.isCompleted = false,
    required this.date,
  });

  // Static list of prayer names
  static const List<String> prayerNames = [
    'Fajr',
    'Dhuhr', 
    'Asr',
    'Maghrib',
    'Isha'
  ];

  static const List<String> arabicNames = [
    'الفجر',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء'
  ];

  // Get prayer emoji
  String get emoji {
    switch (name) {
      case 'Fajr':
        return '🌅';
      case 'Dhuhr':
        return '☀️';
      case 'Asr':
        return '🌤️';
      case 'Maghrib':
        return '🌅';
      case 'Isha':
        return '🌙';
      default:
        return '🕌';
    }
  }

  // Check if prayer time has passed
  bool get hasPassed {
    final now = DateTime.now();
    return now.isAfter(time);
  }

  // Get time until prayer (if not passed)
  Duration? get timeUntil {
    final now = DateTime.now();
    if (hasPassed) return null;
    return time.difference(now);
  }

  // Format time until prayer
  String get timeUntilFormatted {
    final duration = timeUntil;
    if (duration == null) return '';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Prayer copyWith({
    String? name,
    String? arabicName,
    DateTime? time,
    bool? isCompleted,
    DateTime? date,
  }) {
    return Prayer(
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Prayer(name: $name, time: $time, isCompleted: $isCompleted)';
  }
}