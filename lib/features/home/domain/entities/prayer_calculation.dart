class PrayerTimeEntry {
  final String arabicName;
  final String formattedTime;

  const PrayerTimeEntry({
    required this.arabicName,
    required this.formattedTime,
  });
}

class PrayerCalculation {
  final String currentPrayerName;
  final String currentPrayerTime;
  final String nextPrayerName;
  final String remainingTimeText;
  final double progress;
  final List<PrayerTimeEntry> prayerTimes;

  const PrayerCalculation({
    required this.currentPrayerName,
    required this.currentPrayerTime,
    required this.nextPrayerName,
    required this.remainingTimeText,
    required this.progress,
    required this.prayerTimes,
  });
}
