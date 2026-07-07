import 'package:adhan/adhan.dart';

import '../../domain/entities/prayer_calculation.dart';
import '../../domain/repositories/prayer_calculation_repository.dart';

class PrayerCalculationRepositoryImpl implements PrayerCalculationRepository {
  final Coordinates coordinates;

  PrayerCalculationRepositoryImpl({required this.coordinates});

  List<DateTime>? _cachedDates;
  DateTime? _cachedDate;

  static const List<String> _arabicNames = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];

  @override
  PrayerCalculation getPrayerCalculation() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_cachedDates == null || _cachedDate != today) {
      _cachedDates = _calculatePrayerTimes(today);
      _cachedDate = today;
    }

    final dates = _cachedDates!;

    int currentIdx = -1;
    int nextIdx = 0;

    for (int i = 0; i < dates.length; i++) {
      if (now.isBefore(dates[i])) {
        nextIdx = i;
        currentIdx = i - 1;
        break;
      }
    }

    if (currentIdx == -1) {
      currentIdx = dates.length - 1;
    }

    final currentTime = dates[currentIdx];
    final nextTime = dates[nextIdx];

    final Duration remaining;
    final double progress;

    if (now.isBefore(dates[0])) {
      remaining = dates[0].difference(now);
      progress = 1.0 - (remaining.inSeconds / 86400).clamp(0.0, 1.0);
    } else if (now.isAfter(dates.last)) {
      remaining = const Duration(hours: 24);
      progress = 0.0;
    } else {
      remaining = nextTime.difference(now);
      final total = nextTime.difference(currentTime);
      final elapsed = now.difference(currentTime);
      progress = total.inSeconds > 0
          ? (elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0)
          : 0.0;
    }

    final entries = List.generate(dates.length, (i) {
      return PrayerTimeEntry(
        arabicName: _arabicNames[i],
        formattedTime: _formatArabicTime(dates[i]),
      );
    });

    return PrayerCalculation(
      currentPrayerName: _arabicNames[currentIdx],
      currentPrayerTime: _formatArabicTime(currentTime),
      nextPrayerName: _arabicNames[nextIdx],
      remainingTimeText: _formatRemaining(remaining),
      progress: progress,
      prayerTimes: entries,
    );
  }

  List<DateTime> _calculatePrayerTimes(DateTime date) {
    final dateComponents = DateComponents.from(date);
    final params = CalculationMethod.egyptian.getParameters();
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
    return [
      prayerTimes.fajr,
      prayerTimes.sunrise,
      prayerTimes.dhuhr,
      prayerTimes.asr,
      prayerTimes.maghrib,
      prayerTimes.isha,
    ];
  }

  String _formatArabicTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour < 12 ? 'ص' : 'م';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatRemaining(Duration duration) {
    if (duration.isNegative) return 'الآن';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return 'بقي $hours س $minutes د $seconds ث';
    } else if (minutes > 0) {
      return 'بقي $minutes د $seconds ث';
    }
    return 'بقي $seconds ث';
  }
}
