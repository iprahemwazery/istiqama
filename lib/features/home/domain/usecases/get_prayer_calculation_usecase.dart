import '../entities/prayer_calculation.dart';
import '../repositories/prayer_calculation_repository.dart';

class GetPrayerCalculationUseCase {
  final PrayerCalculationRepository repository;

  GetPrayerCalculationUseCase({required this.repository});

  PrayerCalculation call() => repository.getPrayerCalculation();
}
