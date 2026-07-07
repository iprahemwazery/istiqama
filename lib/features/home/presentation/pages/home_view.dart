import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:istiqama/features/azkar/presentation/cubit/azkar_cubit.dart';
import 'package:istiqama/features/azkar/presentation/pages/all_categories_screen.dart';
import 'package:istiqama/features/azkar/presentation/pages/azkar_page.dart';
import 'package:istiqama/features/dream_ai/presentation/pages/dream_ai_page.dart';
import 'package:istiqama/features/hadith/presentation/pages/book_selection_screen.dart';
import 'package:istiqama/features/prayer_times/presentation/pages/prayer_times_page.dart';
import 'package:istiqama/features/quran/presentation/pages/surah_list_page.dart';
import 'package:istiqama/features/tasbih/presentation/pages/tasbih_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/feature_card_widget.dart';
import '../widgets/full_width_action_buttons.dart';
import '../widgets/prayer_card_widget.dart';
import '../widgets/teal_header_widget.dart';
import '../widgets/verse_card_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var widgejsonData;

  Future<void> loadJsonAsset() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/surahs.json',
      );

      var data = jsonDecode(jsonString);

      setState(() {
        widgejsonData = data;
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    loadJsonAsset(); // تحميل البيانات فور فتح التطبيق
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),

      // 🔥 هنا السحر: شيلنا الـ const ومررنا المتغير للـ Body تحت عشان يشوفه
      child: _HomeViewBody(widgejsonData: widgejsonData),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  // 🔥 استقبلنا المتغير هنا جوه الـ StatelessWidget عشان نقدر نستخدمه في الـ Grid

  final dynamic widgejsonData;

  const _HomeViewBody({super.key, required this.widgejsonData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          final screenHeight = MediaQuery.of(context).size.height;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ============= الـ Stack: Background + Prayer Card =============
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.45,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                        child: TealHeaderWidget(
                          title: state.appTitle,
                          subtitle: state.appSubtitle,
                          isDarkMode: state.isDarkMode,
                          onSettingsTap: () {},
                          onDarkModeTap: cubit.toggleDarkMode,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      top: screenHeight * 0.18,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrayerTimesPage(),
                            ),
                          );
                        },
                        child: PrayerCardWidget(
                          currentPrayer: state.currentPrayer,
                          prayers: state.prayers,
                        ),
                      ),
                    ),
                  ],
                ),

                // مسافة بعد كرت الصلاة
                const SizedBox(height: 8),

                // ============= كرت آية اليوم =============
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: VerseCardWidget(verse: state.todaysVerse),
                ),

                // ============= شبكة الخدمات =============
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.features.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.0,
                        ),
                    itemBuilder: (context, index) {
                      final currentFeature = state.features[index];

                      final title = currentFeature.title.toString();

                      return FeatureCardWidget(
                        feature: currentFeature,
                        onTap: () {
                          if (title.contains('باقي الفئات') ||
                              title.contains('أدعية يومية')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => AzkarCubit()..loadAzkar(),
                                  child: const AllCategoriesScreen(),
                                ),
                              ),
                            );
                          } else if (title.contains('الأدعية') ||
                              title.contains('الأذكار')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AzkarPage(),
                              ),
                            );
                          } else if (title.contains('الأذان')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrayerTimesPage(),
                              ),
                            );
                          } else if (title.contains('تفسير')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DreamAiPage(),
                              ),
                            );
                          } else if (title.contains('الحديث')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BookSelectionScreen(),
                              ),
                            );
                          } else if (title.contains('المصحف') ||
                              title.contains('القرآن')) {
                            if (widgejsonData != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuranPage(suraJsonData: widgejsonData),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'جاري تحميل بيانات المصحف... انتظر لحظة واحدة',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ============= أزرار عرض كامل =============
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TasbihButtonWidget(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TasbihPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      QiblaButtonWidget(onTap: () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
