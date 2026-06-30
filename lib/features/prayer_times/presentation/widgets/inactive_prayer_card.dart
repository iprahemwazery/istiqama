import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/prayer_time_entity.dart';

class InactivePrayerCard extends StatelessWidget {
  final PrayerTimeEntity prayerTime;
  final VoidCallback onNotificationToggle;

  const InactivePrayerCard({
    super.key,
    required this.prayerTime,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _PrayerIcon(name: prayerTime.name),
                  SizedBox(width: 12.w),
                  Text(
                    prayerTime.name,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F8056),
                    ),
                  ),
                ],
              ),
              Text(
                prayerTime.time,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F8056),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إشعار',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              _NotificationSwitch(
                value: prayerTime.isNotificationEnabled,
                onChanged: (_) => onNotificationToggle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerIcon extends StatelessWidget {
  final String name;

  const _PrayerIcon({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _iconData,
        color: const Color(0xFF0F8056),
        size: 22.r,
      ),
    );
  }

  IconData get _iconData {
    switch (name) {
      case 'الفجر':
        return Icons.wb_sunny_outlined;
      case 'الشروق':
        return Icons.brightness_5_outlined;
      case 'الظهر':
        return Icons.wb_sunny;
      case 'العصر':
        return Icons.brightness_4_outlined;
      case 'المغرب':
        return Icons.nights_stay_outlined;
      case 'العشاء':
        return Icons.nightlight_outlined;
      default:
        return Icons.access_time;
    }
  }
}

class _NotificationSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _NotificationSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 24.h,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF0F8056),
        activeTrackColor: const Color(0xFF0F8056).withValues(alpha: 0.3),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade200,
      ),
    );
  }
}
