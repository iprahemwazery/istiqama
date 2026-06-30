import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/prayer_times_cubit.dart';

class PrayerHeaderWidget extends StatelessWidget {
  const PrayerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F8056),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45.r),
              bottomRight: Radius.circular(45.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(),
              SizedBox(height: 16.h),
              _TitleSection(),
              SizedBox(height: 24.h),
              _LocationChip(location: state.location),
              SizedBox(height: 24.h),
              _DateCard(
                dayName: state.dayName,
                gregorianDate: state.gregorianDate,
                hijriDate: state.hijriDate,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white, size: 26.r),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 26.r),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'مواقيت الصلاة',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'أوقات دقيقة حسب موقعك',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 15.sp,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String location;

  const _LocationChip({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            location,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.location_on, color: Colors.white, size: 20.r),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String dayName;
  final String gregorianDate;
  final String hijriDate;

  const _DateCard({
    required this.dayName,
    required this.gregorianDate,
    required this.hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A6A45),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            gregorianDate,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            hijriDate,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
