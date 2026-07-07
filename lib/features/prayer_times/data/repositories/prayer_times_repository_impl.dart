import 'package:adhan/adhan.dart';

import '../../domain/entities/prayer_time_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  List<DateTime>? _cachedDates;
  DateTime? _cachedDate;
  double? _cachedLat;
  double? _cachedLng;

  static const List<String> _arabicNames = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];

  @override
  List<PrayerTimeEntity> getPrayerTimes(double latitude, double longitude) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_cachedDates == null ||
        _cachedDate != today ||
        _cachedLat != latitude ||
        _cachedLng != longitude) {
      final coordinates = Coordinates(latitude, longitude);
      _cachedDates = _calculatePrayerTimes(coordinates, today);
      _cachedDate = today;
      _cachedLat = latitude;
      _cachedLng = longitude;
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

    return List.generate(dates.length, (i) {
      final isCurrent = i == currentIdx;
      final isNext = i == nextIdx;
      final time = dates[i];

      String statusText;
      double? remainingPercentage;

      if (isCurrent) {
        if (now.isBefore(time)) {
          final remaining = time.difference(now);
          statusText = _formatRemaining(remaining);
          remainingPercentage = 0.0;
        } else if (nextIdx < dates.length) {
          final nextTime = dates[nextIdx];
          final remaining = nextTime.difference(now);
          statusText = _formatRemaining(remaining);
          final total = nextTime.difference(time);
          final elapsed = now.difference(time);
          remainingPercentage = total.inSeconds > 0
              ? (1.0 - (elapsed.inSeconds / total.inSeconds)).clamp(0.0, 1.0)
              : 0.0;
        } else {
          statusText = 'انتهت الصلوات';
          remainingPercentage = 1.0;
        }
      } else if (isNext) {
        final remaining = time.difference(now);
        statusText = remaining.isNegative
            ? 'الآن'
            : 'متبقي ${_formatRemaining(remaining)}';
        remainingPercentage = null;
      } else {
        statusText = 'قادمة';
        remainingPercentage = null;
      }

      return PrayerTimeEntity(
        name: _arabicNames[i],
        time: _formatArabicTime(time),
        isNotificationEnabled: false,
        isCurrent: isCurrent || (i == dates.length - 1 && now.isAfter(dates.last)),
        statusText: statusText,
        remainingPercentage: remainingPercentage,
      );
    });
  }

  List<DateTime> _calculatePrayerTimes(Coordinates coordinates, DateTime date) {
    final dateComponents = DateComponents.from(date);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
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
