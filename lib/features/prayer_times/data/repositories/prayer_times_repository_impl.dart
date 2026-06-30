import '../../domain/entities/prayer_time_entity.dart';
import '../../domain/repositories/prayer_times_repository.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  @override
  List<PrayerTimeEntity> getPrayerTimes() {
    return [
      const PrayerTimeEntity(
        name: 'الفجر',
        time: '5:15',
        isNotificationEnabled: true,
        isCurrent: false,
        statusText: 'قادمة',
      ),
      const PrayerTimeEntity(
        name: 'الشروق',
        time: '6:30',
        isNotificationEnabled: false,
        isCurrent: false,
        statusText: 'قادمة',
      ),
      const PrayerTimeEntity(
        name: 'الظهر',
        time: '12:15',
        isNotificationEnabled: true,
        isCurrent: true,
        statusText: 'بعد ساعة و 15 دقيقة',
        remainingPercentage: 0.45,
      ),
      const PrayerTimeEntity(
        name: 'العصر',
        time: '15:30',
        isNotificationEnabled: true,
        isCurrent: false,
        statusText: 'قادمة',
      ),
      const PrayerTimeEntity(
        name: 'المغرب',
        time: '18:20',
        isNotificationEnabled: true,
        isCurrent: false,
        statusText: 'قادمة',
      ),
      const PrayerTimeEntity(
        name: 'العشاء',
        time: '19:45',
        isNotificationEnabled: false,
        isCurrent: false,
        statusText: 'قادمة',
      ),
    ];
  }
}
