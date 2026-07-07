import 'dart:async';

import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import 'package:istiqama/core/services/location_service.dart';
import 'package:istiqama/core/services/notification_service.dart';
import 'package:istiqama/core/utils/save_manager.dart';
import 'package:istiqama/features/prayer_times/data/repositories/prayer_times_repository_impl.dart';
import 'package:istiqama/features/prayer_times/domain/entities/prayer_time_entity.dart';
import 'package:istiqama/features/prayer_times/domain/usecases/get_prayer_times_usecase.dart';
import 'package:istiqama/features/prayer_times/domain/usecases/toggle_notification_usecase.dart';

part 'prayer_times_state.dart';

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  final GetPrayerTimesUseCase _getPrayerTimesUseCase;
  final ToggleNotificationUseCase _toggleNotificationUseCase;
  final LocationService _locationService;
  Timer? _timer;
  double? _latitude;
  double? _longitude;
  DateTime? _lastScheduledDate;

  PrayerTimesCubit()
      : _getPrayerTimesUseCase = GetPrayerTimesUseCase(
          repository: PrayerTimesRepositoryImpl(),
        ),
        _toggleNotificationUseCase = ToggleNotificationUseCase(),
        _locationService = LocationService(),
        super(const PrayerTimesState()) {
    _loadLocationAndPrayerTimes();
  }

  Future<void> _loadLocationAndPrayerTimes() async {
    final hasSaved = await SaveManager.hasSavedLocation();
    if (hasSaved) {
      final lat = await SaveManager.getSavedLatitude();
      final lng = await SaveManager.getSavedLongitude();
      if (lat != null && lng != null) {
        _latitude = lat;
        _longitude = lng;
        emit(state.copyWith(status: PrayerTimesStatus.loading));
        _refresh();
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
        return;
      }
    }

    emit(state.copyWith(status: PrayerTimesStatus.locationLoading));

    try {
      final isEnabled = await _locationService.isServiceEnabled();
      if (!isEnabled) {
        emit(state.copyWith(
          status: PrayerTimesStatus.locationDisabled,
          errorMessage: 'خدمات الموقع معطلة. يرجى تفعيلها من الإعدادات',
        ));
        return;
      }

      final permission = await _locationService.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
          status: PrayerTimesStatus.locationDenied,
          errorMessage: 'تم رفض إذن الوصول إلى الموقع',
        ));
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          status: PrayerTimesStatus.locationDenied,
          errorMessage: 'تم رفض إذن الموقع بشكل دائم. يرجى تفعيله من الإعدادات',
        ));
        return;
      }

      emit(state.copyWith(status: PrayerTimesStatus.loading));

      final position = await _locationService.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
      await SaveManager.saveLocation(position.latitude, position.longitude);

      _refresh();
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
    } catch (e) {
      emit(state.copyWith(
        status: PrayerTimesStatus.error,
        errorMessage: 'حدث خطأ أثناء تحميل مواقيت الصلاة',
      ));
    }
  }

  void retry() {
    _timer?.cancel();
    _loadLocationAndPrayerTimes();
  }

  void _refresh() {
    if (_latitude == null || _longitude == null) return;

    try {
      final now = DateTime.now();
      final prayers = _getPrayerTimesUseCase.call(_latitude!, _longitude!);
      final locationStr =
          '${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)}';

      emit(state.copyWith(
        status: PrayerTimesStatus.loaded,
        prayerTimes: prayers,
        location: locationStr,
        gregorianDate: _formatGregorianDate(now),
        hijriDate: _formatHijriDate(now),
        dayName: _dayNameArabic(now.weekday),
        latitude: _latitude,
        longitude: _longitude,
      ));

      _scheduleNotifications();
    } catch (e) {
      emit(state.copyWith(
        status: PrayerTimesStatus.error,
        errorMessage: 'حدث خطأ في حساب مواقيت الصلاة',
      ));
    }
  }

  void _scheduleNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_lastScheduledDate == today) return;
    _lastScheduledDate = today;

    final coordinates = adhan.Coordinates(_latitude!, _longitude!);
    final dateComponents = adhan.DateComponents.from(now);
    final params = adhan.CalculationMethod.egyptian.getParameters();
    params.madhab = adhan.Madhab.shafi;
    final prayerTimes = adhan.PrayerTimes(coordinates, dateComponents, params);

    NotificationService().schedulePrayerNotifications(prayerTimes);
  }

  void toggleNotification(int index) {
    final updated = _toggleNotificationUseCase.call(state.prayerTimes, index);
    emit(state.copyWith(prayerTimes: updated));
  }

  String _formatGregorianDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _dayNameArabic(int weekday) {
    const days = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد',
    ];
    return days[weekday - 1];
  }

  String _formatHijriDate(DateTime date) {
    final jd = _gregorianToJulianDay(date);
    final hijri = _julianDayToHijri(jd);
    const hijriMonths = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    return '${hijri.day} ${hijriMonths[hijri.month - 1]} ${hijri.year}';
  }

  int _gregorianToJulianDay(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;
    final a = (14 - m) ~/ 12;
    final y2 = y + 4800 - a;
    final m2 = m + 12 * a - 3;
    return d + (153 * m2 + 2) ~/ 5 + 365 * y2 + y2 ~/ 4 - y2 ~/ 100 + y2 ~/ 400 - 32045;
  }

  _HijriDate _julianDayToHijri(int jd) {
    final l = jd - 1948440 + 10632;
    final n = (l - 1) ~/ 10631;
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) ~/ 5316) * ((50 * l2) ~/ 17719) + (l2 ~/ 5670) * ((43 * l2) ~/ 15238);
    final l3 = l2 - ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) - (j ~/ 16) * ((15238 * j) ~/ 43) + 29;
    final month = (24 * l3) ~/ 709;
    final day = l3 - (month * 709) ~/ 24;
    final year = 30 * n + j - 30;
    return _HijriDate(year: year, month: month, day: day);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class _HijriDate {
  final int year;
  final int month;
  final int day;
  const _HijriDate({required this.year, required this.month, required this.day});
}
