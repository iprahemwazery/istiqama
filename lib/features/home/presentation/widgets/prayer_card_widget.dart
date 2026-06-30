import 'package:flutter/material.dart';

import '../../presentation/cubit/home_state.dart';
import '../../data/models/current_prayer_model.dart';
import '../../data/models/prayer_model.dart';

class PrayerCardWidget extends StatelessWidget {
  final CurrentPrayerModel currentPrayer;
  final List<PrayerModel> prayers;

  const PrayerCardWidget({
    super.key,
    required this.currentPrayer,
    required this.prayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currentPrayer.time,
                        style: const TextStyle(
                          color: HomeColors.primaryGreen,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(
                          Icons.access_time,
                          color: HomeColors.primaryGreen,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentPrayer.remainingTime,
                    style: const TextStyle(
                      color: HomeColors.primaryGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // اسم الصلاة على اليمين
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentPrayer.nextPrayerName,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentPrayer.name,
                    style: const TextStyle(
                      color: HomeColors.primaryGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ======= شريط التقدم في الأسفل =======
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: currentPrayer.progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: HomeColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ======= أوقات الصلوات =======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: prayers.map((p) => _PrayerItemWidget(prayer: p)).toList(),
          ),
        ],
      ),
    );
  }
}

class _PrayerItemWidget extends StatelessWidget {
  final PrayerModel prayer;
  const _PrayerItemWidget({required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: prayer.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(prayer.icon, color: prayer.color, size: 18),
        ),
        const SizedBox(height: 5),
        Text(
          prayer.name,
          style: const TextStyle(
            fontSize: 10,
            color: HomeColors.primaryGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          prayer.time,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
