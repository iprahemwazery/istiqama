import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/save_manager.dart';
import '../../data/models/current_prayer_model.dart';
import '../../data/models/feature_model.dart';
import '../../data/models/prayer_model.dart';
import '../../data/models/verse_model.dart';
import '../../data/repositories/prayer_calculation_repository_impl.dart';
import '../../domain/entities/prayer_calculation.dart';
import '../../domain/usecases/get_prayer_calculation_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationService _locationService = LocationService();
  late final GetPrayerCalculationUseCase _useCase;
  Timer? _timer;
  Coordinates? _coordinates;
  DateTime? _lastScheduledDate;

  HomeCubit()
    : super(
        const HomeState(
          isDarkMode: false,
          appTitle: 'المصحف الشريف',
          appSubtitle: 'السلام عليكم ورحمة الله',
          currentPrayer: CurrentPrayerModel(
            name: 'الفجر',
            time: '--:--',
            remainingTime: 'جاري التحميل...',
            nextPrayerName: 'الصلاة القادمة',
            progress: 0,
          ),
          prayers: [],
          todaysVerse: VerseModel(
            title: 'آية اليوم',
            text: '﴾ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴿',
            surahName: 'سورة طه - آية 114',
            verseNumber: '114',
          ),
          features: [
            FeatureModel(
              title: 'الأذان',
              subtitle: 'مواقيت الصلاة',
              icon: Icons.access_time,
              iconColor: HomeColors.gold,
              backgroundColor: HomeColors.gold,
            ),
            FeatureModel(
              title: 'المصحف',
              subtitle: 'قراءة القرآن الكريم',
              icon: Icons.menu_book,
              iconColor: HomeColors.primaryGreen,
              backgroundColor: HomeColors.primaryGreen,
            ),
            FeatureModel(
              title: 'التذكيرات',
              subtitle: 'تنبيهات يومية',
              icon: Icons.notifications_active,
              iconColor: HomeColors.gold,
              backgroundColor: HomeColors.gold,
            ),
            FeatureModel(
              title: 'الأدعية والأذكار',
              subtitle: 'حصن المسلم',
              icon: Icons.pan_tool,
              iconColor: HomeColors.primaryGreen,
              backgroundColor: HomeColors.primaryGreen,
            ),
            FeatureModel(
              title: 'المساجد',
              subtitle: 'أقرب المساجد',
              icon: Icons.location_on,
              iconColor: HomeColors.gold,
              backgroundColor: HomeColors.gold,
            ),
            FeatureModel(
              title: 'المساجد',
              subtitle: 'أقرب المساجد',
              icon: Icons.location_on,
              iconColor: HomeColors.gold,
              backgroundColor: HomeColors.gold,
            ),
            FeatureModel(
              title: 'الحديث',
              subtitle: 'الحدايث النبويه',
              icon: Icons.auto_stories,
              iconColor: HomeColors.gold,
              backgroundColor: HomeColors.gold,
            ),
            FeatureModel(
              title: 'تعليم القرآن',
              subtitle: 'دروس وتلاوات',
              icon: Icons.headphones,
              iconColor: HomeColors.primaryGreen,
              backgroundColor: HomeColors.primaryGreen,
            ),
          ],
        ),
      ) {
    _initLocation();
  }

  Future<void> _initLocation() async {
    final hasSaved = await SaveManager.hasSavedLocation();
    if (hasSaved) {
      final lat = await SaveManager.getSavedLatitude();
      final lng = await SaveManager.getSavedLongitude();
      if (lat != null && lng != null) {
        _coordinates = Coordinates(lat, lng);
        _useCase = GetPrayerCalculationUseCase(
          repository: PrayerCalculationRepositoryImpl(
            coordinates: _coordinates!,
          ),
        );
        _startTimer();
        return;
      }
    }

    var permission = await _locationService.requestPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _coordinates = Coordinates(30.0444, 31.2357);
      _useCase = GetPrayerCalculationUseCase(
        repository: PrayerCalculationRepositoryImpl(
          coordinates: _coordinates!,
        ),
      );
    } else {
      try {
        final position = await _locationService.getCurrentPosition();
        await SaveManager.saveLocation(position.latitude, position.longitude);
        _coordinates = Coordinates(position.latitude, position.longitude);
        _useCase = GetPrayerCalculationUseCase(
          repository: PrayerCalculationRepositoryImpl(
            coordinates: _coordinates!,
          ),
        );
      } catch (_) {
        _coordinates = Coordinates(30.0444, 31.2357);
        _useCase = GetPrayerCalculationUseCase(
          repository: PrayerCalculationRepositoryImpl(
            coordinates: _coordinates!,
          ),
        );
      }
    }
    _startTimer();
  }

  void _startTimer() {
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
  }

  void _refresh() {
    final calc = _useCase();
    final prayers = _buildPrayerList(calc);

    emit(
      state.copyWith(
        currentPrayer: CurrentPrayerModel(
          name: calc.nextPrayerName,
          time: calc.currentPrayerTime,
          remainingTime: calc.remainingTimeText,
          nextPrayerName: 'الصلاة القادمة',
          progress: calc.progress,
        ),
        prayers: prayers,
      ),
    );

    if (_coordinates != null) {
      _schedulePrayerAlarms();
    }
  }

  void _schedulePrayerAlarms() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_lastScheduledDate == today) return;
    _lastScheduledDate = today;

    final dateComponents = DateComponents.from(now);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes(_coordinates!, dateComponents, params);
    NotificationService().schedulePrayerNotifications(prayerTimes);
  }

  List<PrayerModel> _buildPrayerList(PrayerCalculation calc) {
    return calc.prayerTimes.map((entry) {
      final isCurrent = entry.arabicName == calc.currentPrayerName;
      return PrayerModel(
        name: entry.arabicName,
        time: entry.formattedTime,
        icon: _prayerIcon(entry.arabicName),
        color: isCurrent ? HomeColors.gold : HomeColors.primaryGreen,
      );
    }).toList();
  }

  static IconData _prayerIcon(String name) {
    switch (name) {
      case 'الفجر':
        return Icons.nightlight_round;
      case 'الشروق':
        return Icons.wb_twilight;
      case 'الظهر':
        return Icons.wb_sunny;
      case 'العصر':
        return Icons.wb_sunny;
      case 'المغرب':
        return Icons.nights_stay;
      case 'العشاء':
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
  }

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
