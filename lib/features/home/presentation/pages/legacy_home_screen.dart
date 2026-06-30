import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istiqama/core/constants/app_constants.dart';
import 'package:istiqama/core/theme/app_theme.dart';
import 'package:istiqama/features/quran/presentation/pages/surah_list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // المتغير الذي سيحمل بيانات السور
  var widgejsonData;

  // دالة قراءة ملف الـ JSON التي قمت بكتابتها
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
      // طباعة الخطأ في حال لم يجد الملف أو كان هناك مشكلة بالـ JSON
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
    return Scaffold(
      backgroundColor: quranPagesColor, // استخدام لون الخلفية الخاص بك
      appBar: AppBar(title: const Text('الرئيسية'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // كرت القرآن الكريم
            ServiceCard(
              icon: Icons.book,
              title: 'القرآن الكريم',
              onTap: () {
                // التحقق من أن البيانات تم تحميلها بنجاح قبل الانتقال
                if (widgejsonData != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuranPage(suraJsonData: widgejsonData),
                    ),
                  );
                } else {
                  // رسالة تنبيه للمستخدم في حال لم ينتهِ التحميل بعد (تحدث في أجزاء من الثانية)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('جاري تحميل البيانات... انتظر لحظة'),
                    ),
                  );
                }
              },
            ),
            // كرت أذكار الصباح والمساء
            ServiceCard(
              icon: Icons.access_time,
              title: 'أذكار الصباح والمساء',
              onTap: () {
                // TODO: Implement Adhkar screen navigation
              },
            ),
            // كرت مواقيت الصلاة
            ServiceCard(
              icon: Icons.schedule,
              title: 'مواقيت الصلاة',
              onTap: () {
                // TODO: Implement Prayer Times screen navigation
              },
            ),
            // كرت الأحاديث
            ServiceCard(
              icon: Icons.format_quote,
              title: 'الأحاديث',
              onTap: () {
                // TODO: Implement Hadith screen navigation
              },
            ),
            // كرت الأدعية
            ServiceCard(
              icon: Icons.handshake,
              title: 'الأدعية',
              onTap: () {
                // TODO: Implement Duas screen navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}

// كرت الخدمات (الـ Widget المخصص) كما هو دون تغيير
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ServiceCard({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppTheme.primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
