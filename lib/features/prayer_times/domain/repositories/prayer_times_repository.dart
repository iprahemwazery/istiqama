import '../entities/prayer_time_entity.dart';

abstract class PrayerTimesRepository {
  List<PrayerTimeEntity> getPrayerTimes(double latitude, double longitude);
}
