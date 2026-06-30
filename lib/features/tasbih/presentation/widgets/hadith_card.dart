import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEEDDAA),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A24C).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              color: const Color(0xFFD4A24C),
              size: 22.r,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ فِي يَوْمٍ مِائَةَ مَرَّةٍ حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15.sp,
              height: 1.6,
              color: const Color(0xFF5D4037),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'رواه البخاري ومسلم',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13.sp,
              color: const Color(0xFF8D6E63),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
