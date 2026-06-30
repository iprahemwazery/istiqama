import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/current_prayer_model.dart';
import '../../data/models/feature_model.dart';
import '../../data/models/prayer_model.dart';
import '../../data/models/verse_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          const HomeState(
            isDarkMode: false,
            appTitle: 'المصحف الشريف',
            appSubtitle: 'السلام عليكم ورحمة الله',
            currentPrayer: CurrentPrayerModel(
              name: 'صلاة الظهر',
              time: '12:30',
              remainingTime: 'بقي ساعة و 15 دقيقة',
              nextPrayerName: 'الصلاة القادمة',
              progress: 0.5,
            ),
            prayers: [
              PrayerModel(
                name: 'الفجر',
                time: '5:15',
                icon: Icons.nightlight_round,
                color: HomeColors.gold,
              ),
              PrayerModel(
                name: 'الشروق',
                time: '6:45',
                icon: Icons.wb_twilight,
                color: HomeColors.gold,
              ),
              PrayerModel(
                name: 'العصر',
                time: '3:45',
                icon: Icons.wb_sunny,
                color: HomeColors.gold,
              ),
              PrayerModel(
                name: 'المغرب',
                time: '6:15',
                icon: Icons.nights_stay,
                color: HomeColors.gold,
              ),
              PrayerModel(
                name: 'العشاء',
                time: '7:45',
                icon: Icons.bedtime,
                color: HomeColors.gold,
              ),
            ],
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
                title: 'أدعية يومية',
                subtitle: 'أدعية وأذكار متنوعة',
                icon: Icons.auto_awesome,
                iconColor: HomeColors.primaryGreen,
                backgroundColor: HomeColors.primaryGreen,
              ),
              FeatureModel(
                title: 'باقي الفئات',
                subtitle: 'جميع الأذكار المتنوعة',
                icon: Icons.dashboard,
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
                title: 'تعليم القرآن',
                subtitle: 'دروس وتلاوات',
                icon: Icons.headphones,
                iconColor: HomeColors.primaryGreen,
                backgroundColor: HomeColors.primaryGreen,
              ),
            ],
          ),
        );

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
