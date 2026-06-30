part of 'prayer_times_cubit.dart';

class PrayerTimesState extends Equatable {
  final List<PrayerTimeEntity> prayerTimes;
  final String location;
  final String gregorianDate;
  final String hijriDate;
  final String dayName;

  const PrayerTimesState({
    this.prayerTimes = const [],
    this.location = '',
    this.gregorianDate = '',
    this.hijriDate = '',
    this.dayName = '',
  });

  PrayerTimesState copyWith({
    List<PrayerTimeEntity>? prayerTimes,
    String? location,
    String? gregorianDate,
    String? hijriDate,
    String? dayName,
  }) {
    return PrayerTimesState(
      prayerTimes: prayerTimes ?? this.prayerTimes,
      location: location ?? this.location,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      hijriDate: hijriDate ?? this.hijriDate,
      dayName: dayName ?? this.dayName,
    );
  }

  @override
  List<Object?> get props => [
        prayerTimes,
        location,
        gregorianDate,
        hijriDate,
        dayName,
      ];
}
