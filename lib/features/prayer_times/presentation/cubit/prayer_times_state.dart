part of 'prayer_times_cubit.dart';

enum PrayerTimesStatus {
  initial,
  locationLoading,
  locationDenied,
  locationDisabled,
  loading,
  loaded,
  error,
}

class PrayerTimesState extends Equatable {
  final PrayerTimesStatus status;
  final String errorMessage;
  final List<PrayerTimeEntity> prayerTimes;
  final String location;
  final String gregorianDate;
  final String hijriDate;
  final String dayName;
  final double? latitude;
  final double? longitude;

  const PrayerTimesState({
    this.status = PrayerTimesStatus.initial,
    this.errorMessage = '',
    this.prayerTimes = const [],
    this.location = '',
    this.gregorianDate = '',
    this.hijriDate = '',
    this.dayName = '',
    this.latitude,
    this.longitude,
  });

  PrayerTimesState copyWith({
    PrayerTimesStatus? status,
    String? errorMessage,
    List<PrayerTimeEntity>? prayerTimes,
    String? location,
    String? gregorianDate,
    String? hijriDate,
    String? dayName,
    double? latitude,
    double? longitude,
  }) {
    return PrayerTimesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      location: location ?? this.location,
      gregorianDate: gregorianDate ?? this.gregorianDate,
      hijriDate: hijriDate ?? this.hijriDate,
      dayName: dayName ?? this.dayName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        prayerTimes,
        location,
        gregorianDate,
        hijriDate,
        dayName,
        latitude,
        longitude,
      ];
}
