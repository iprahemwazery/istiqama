import 'package:equatable/equatable.dart';

class CurrentPrayerModel extends Equatable {
  final String name;
  final String time;
  final String remainingTime;
  final String nextPrayerName;
  final double progress;

  const CurrentPrayerModel({
    required this.name,
    required this.time,
    required this.remainingTime,
    required this.nextPrayerName,
    required this.progress,
  });

  @override
  List<Object?> get props => [
    name,
    time,
    remainingTime,
    nextPrayerName,
    progress,
  ];
}
