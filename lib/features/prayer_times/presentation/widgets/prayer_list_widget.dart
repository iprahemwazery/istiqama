import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/prayer_time_entity.dart';
import 'active_prayer_card.dart';
import 'inactive_prayer_card.dart';

class PrayerListWidget extends StatelessWidget {
  final List<PrayerTimeEntity> prayerTimes;
  final void Function(int) onNotificationToggle;

  const PrayerListWidget({
    super.key,
    required this.prayerTimes,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      itemCount: prayerTimes.length,
      itemBuilder: (context, index) {
        final prayer = prayerTimes[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: prayer.isCurrent
              ? ActivePrayerCard(
                  prayerTime: prayer,
                  onNotificationToggle: () => onNotificationToggle(index),
                )
              : InactivePrayerCard(
                  prayerTime: prayer,
                  onNotificationToggle: () => onNotificationToggle(index),
                ),
        );
      },
    );
  }
}
