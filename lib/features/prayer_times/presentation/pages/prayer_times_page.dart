import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_service.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/prayer_header_widget.dart';
import '../widgets/prayer_list_widget.dart';

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => PrayerTimesCubit(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
              builder: (context, state) {
                switch (state.status) {
                  case PrayerTimesStatus.locationLoading:
                  case PrayerTimesStatus.loading:
                    return _buildLoading();
                  case PrayerTimesStatus.locationDenied:
                  case PrayerTimesStatus.locationDisabled:
                    return _buildLocationError(state, context);
                  case PrayerTimesStatus.error:
                    return _buildError(state, context);
                  case PrayerTimesStatus.loaded:
                    return _buildPrayerTimes(state, context);
                  case PrayerTimesStatus.initial:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF0F8056)),
          SizedBox(height: 16),
          Text(
            'جاري تحميل مواقيت الصلاة...',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationError(PrayerTimesState state, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.status == PrayerTimesStatus.locationDisabled
                  ? Icons.location_off
                  : Icons.location_disabled,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<PrayerTimesCubit>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F8056),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(PrayerTimesState state, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<PrayerTimesCubit>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F8056),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimes(PrayerTimesState state, BuildContext context) {
    return Column(
      children: [
        const PrayerHeaderWidget(),
        Expanded(
          child: PrayerListWidget(
            prayerTimes: state.prayerTimes,
            onNotificationToggle: (index) =>
                context.read<PrayerTimesCubit>().toggleNotification(index),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final enabled =
                        await NotificationService().areNotificationsEnabled();
                    if (!enabled) {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('تفعيل الإشعارات'),
                          content: const Text(
                            'الإشعارات غير مفعلة.\n\n'
                            'على أجهزة Realme يرجى تفعيل:\n'
                            '1. الإشعارات (Notifications)\n'
                            '2. بدء التشغيل التلقائي (Auto-launch)\n'
                            '3. تحسين البطارية (Battery Optimization)\n\n'
                            'اختر ما تريد فتحه:',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                NotificationService().openBatteryOptimizationSettings();
                              },
                              child: const Text('البطارية'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                NotificationService().openNotificationSettings();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F8056),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('الإشعارات'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    NotificationService().showTestNotification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال الإشعار الفوري وآخر مجدول بعد 10 ثوانٍ'),
                        backgroundColor: Color(0xFF0F8056),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('اختبار الإشعار (Flutter)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F8056),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await NotificationService().startForegroundService();
                    await NotificationService().testRealBackgroundNotification(
                      delaySeconds: 15,
                    );
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('✅ اختبار الخدمة الخلفية'),
                          content: const Text(
                            '🚀 تم تشغيل الخدمة الخلفية!\n\n'
                            '🕐 سيصلك إشعار بعد 15 ثانية.\n\n'
                            '📌 الآن أخرج من التطبيق بالكامل:\n'
                            '- اضغط على زر Recent Apps 🗂️\n'
                            '- اسحب التطبيق لإغلاقه (Force Close)\n'
                            '- اقفل الشاشة 🔒\n\n'
                            'إذا وصلتك رسالة بعد 15 ثانية → الخدمة شغالة ✅\n'
                            'إذا ما وصلتك → في مشكلة ❌',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ctx.findAncestorStateOfType<NavigatorState>()
                                    ?.pop();
                              },
                              child: const Text('فهمت'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bug_report),
                  label: const Text('🧪 اختبار الخلفية (Force Close)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
