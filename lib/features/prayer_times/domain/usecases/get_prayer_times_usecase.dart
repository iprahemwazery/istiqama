import '../entities/prayer_time_entity.dart';
import '../repositories/prayer_times_repository.dart';

class GetPrayerTimesUseCase {
  final PrayerTimesRepository repository;

  GetPrayerTimesUseCase({required this.repository});

  List<PrayerTimeEntity> call() {
    return repository.getPrayerTimes();
  }
}
