import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:istiqama/features/prayer_times/data/repositories/prayer_times_repository_impl.dart';
import 'package:istiqama/features/prayer_times/domain/entities/prayer_time_entity.dart';
import 'package:istiqama/features/prayer_times/domain/usecases/get_prayer_times_usecase.dart';
import 'package:istiqama/features/prayer_times/domain/usecases/toggle_notification_usecase.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final GetPrayerTimesUseCase _getPrayerTimesUseCase;
  final ToggleNotificationUseCase _toggleNotificationUseCase;

  PrayerTimesCubit()
    : _getPrayerTimesUseCase = GetPrayerTimesUseCase(
        repository: PrayerTimesRepositoryImpl(),
      ),
      _toggleNotificationUseCase = ToggleNotificationUseCase(),
      super(const PrayerTimesState());

  void loadPrayerTimes() {
    final prayers = _getPrayerTimesUseCase.call();
    emit(
      state.copyWith(
        prayerTimes: prayers,
        location: 'الرياض، المملكة العربية السعودية',
        gregorianDate: '21 أكتوبر 2025',
        hijriDate: '28 ربيع الثاني 1447',
        dayName: 'الثلاثاء',
      ),
    );
  }

  void toggleNotification(int index) {
    final updated = _toggleNotificationUseCase.call(state.prayerTimes, index);
    emit(state.copyWith(prayerTimes: updated));
  }
}
