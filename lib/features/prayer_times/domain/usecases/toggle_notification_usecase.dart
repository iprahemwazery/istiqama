import '../entities/prayer_time_entity.dart';

class ToggleNotificationUseCase {
  List<PrayerTimeEntity> call(List<PrayerTimeEntity> prayerTimes, int index) {
    final updated = List<PrayerTimeEntity>.from(prayerTimes);
    updated[index] = updated[index].copyWith(
      isNotificationEnabled: !updated[index].isNotificationEnabled,
    );
    return updated;
  }
}
