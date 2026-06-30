import '../../domain/entities/prayer_time_entity.dart';

class PrayerTimeModel extends PrayerTimeEntity {
  const PrayerTimeModel({
    required super.name,
    required super.time,
    required super.isNotificationEnabled,
    required super.isCurrent,
    required super.statusText,
    super.remainingPercentage,
  });

  factory PrayerTimeModel.fromEntity(PrayerTimeEntity entity) {
    return PrayerTimeModel(
      name: entity.name,
      time: entity.time,
      isNotificationEnabled: entity.isNotificationEnabled,
      isCurrent: entity.isCurrent,
      statusText: entity.statusText,
      remainingPercentage: entity.remainingPercentage,
    );
  }

  PrayerTimeEntity toEntity() {
    return PrayerTimeEntity(
      name: name,
      time: time,
      isNotificationEnabled: isNotificationEnabled,
      isCurrent: isCurrent,
      statusText: statusText,
      remainingPercentage: remainingPercentage,
    );
  }
}
