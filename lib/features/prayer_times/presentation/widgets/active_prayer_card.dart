import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/prayer_time_entity.dart';

class ActivePrayerCard extends StatelessWidget {
  final PrayerTimeEntity prayerTime;
  final VoidCallback onNotificationToggle;

  const ActivePrayerCard({
    super.key,
    required this.prayerTime,
    required this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F8056),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _PrayerIcon(name: prayerTime.name, isActive: true),
                  SizedBox(width: 12.w),
                  Text(
                    prayerTime.name,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                prayerTime.time,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            prayerTime.statusText,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مفعل',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              _NotificationSwitch(
                value: prayerTime.isNotificationEnabled,
                onChanged: (_) => onNotificationToggle(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (prayerTime.remainingPercentage != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الوقت المتبقي',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  '${(prayerTime.remainingPercentage! * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: prayerTime.remainingPercentage,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                color: const Color(0xFFFFD700),
                minHeight: 6.h,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrayerIcon extends StatelessWidget {
  final String name;
  final bool isActive;

  const _PrayerIcon({required this.name, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.15)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _iconData,
        color: isActive ? Colors.white : const Color(0xFF0F8056),
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
        activeThumbColor: const Color(0xFFFFD700),
        activeTrackColor: Colors.white.withValues(alpha: 0.3),
        inactiveThumbColor: Colors.white.withValues(alpha: 0.6),
        inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
      ),
    );
  }
}
