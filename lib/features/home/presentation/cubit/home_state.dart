import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/current_prayer_model.dart';
import '../../data/models/feature_model.dart';
import '../../data/models/prayer_model.dart';
import '../../data/models/verse_model.dart';

class HomeState extends Equatable {
  final bool isDarkMode;
  final CurrentPrayerModel currentPrayer;
  final List<PrayerModel> prayers;
  final VerseModel todaysVerse;
  final List<FeatureModel> features;
  final String appTitle;
  final String appSubtitle;

  const HomeState({
    required this.isDarkMode,
    required this.currentPrayer,
    required this.prayers,
    required this.todaysVerse,
    required this.features,
    required this.appTitle,
    required this.appSubtitle,
  });

  HomeState copyWith({
    bool? isDarkMode,
    CurrentPrayerModel? currentPrayer,
    List<PrayerModel>? prayers,
    VerseModel? todaysVerse,
    List<FeatureModel>? features,
    String? appTitle,
    String? appSubtitle,
  }) {
    return HomeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentPrayer: currentPrayer ?? this.currentPrayer,
      prayers: prayers ?? this.prayers,
      todaysVerse: todaysVerse ?? this.todaysVerse,
      features: features ?? this.features,
      appTitle: appTitle ?? this.appTitle,
      appSubtitle: appSubtitle ?? this.appSubtitle,
    );
  }

  @override
  List<Object?> get props => [
    isDarkMode,
    currentPrayer,
    prayers,
    todaysVerse,
    features,
    appTitle,
    appSubtitle,
  ];
}

class HomeColors {
  static const Color primaryGreen = Color(0xFF0D7E5E);
  static const Color gold = Color(0xFFD4A24C);
  static const Color cream = Color(0xFFFCEFCF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color lightGreen = Color(0xFF11A47E);

  static LinearGradient get tealGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF11A47E), Color(0xFF0D7E5E)],
  );
}
