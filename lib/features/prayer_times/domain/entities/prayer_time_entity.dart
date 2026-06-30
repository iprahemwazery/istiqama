class PrayerTimeEntity {
  final String name;
  final String time;
  final bool isNotificationEnabled;
  final bool isCurrent;
  final String statusText;
  final double? remainingPercentage;

  const PrayerTimeEntity({
    required this.name,
    required this.time,
    required this.isNotificationEnabled,
    required this.isCurrent,
    required this.statusText,
    this.remainingPercentage,
  });

  PrayerTimeEntity copyWith({
    String? name,
    String? time,
    bool? isNotificationEnabled,
    bool? isCurrent,
    String? statusText,
    double? remainingPercentage,
  }) {
    return PrayerTimeEntity(
      name: name ?? this.name,
      time: time ?? this.time,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
      isCurrent: isCurrent ?? this.isCurrent,
      statusText: statusText ?? this.statusText,
      remainingPercentage: remainingPercentage ?? this.remainingPercentage,
    );
  }
}
