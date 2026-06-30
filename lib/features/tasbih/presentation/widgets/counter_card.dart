import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/phrase_entity.dart';

class CounterCard extends StatelessWidget {
  final PhraseEntity activePhrase;
  final int totalToday;
  final int rounds;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  const CounterCard({
    super.key,
    required this.activePhrase,
    required this.totalToday,
    required this.rounds,
    required this.onIncrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final progress = activePhrase.target > 0
        ? (activePhrase.currentCount / activePhrase.target).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      child: Column(
        children: [
          Text(
            activePhrase.text,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00695C),
            ),
          ),
          SizedBox(height: 24.h),
          _CircularCounter(
            currentCount: activePhrase.currentCount,
            target: activePhrase.target,
            progress: progress,
          ),
          SizedBox(height: 20.h),
          _buildLinearProgress(progress),
          SizedBox(height: 28.h),
          _buildFloatingActionButton(),
          SizedBox(height: 24.h),
          _buildStatsBar(),
        ],
      ),
    );
  }

  Widget _buildLinearProgress(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey.shade200,
        color: const Color(0xFF00695C),
        minHeight: 6.h,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: onIncrement,
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          color: const Color(0xFF00695C),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00695C).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تسبيح',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'اضغط للعد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'الجولات', value: '$rounds'),
          Container(
            width: 1,
            height: 30.h,
            color: Colors.grey.shade300,
          ),
          _StatItem(label: 'الإجمالي اليوم', value: '$totalToday'),
          Container(
            width: 1,
            height: 30.h,
            color: Colors.grey.shade300,
          ),
          GestureDetector(
            onTap: onReset,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 16.r, color: const Color(0xFF00695C)),
                  SizedBox(width: 6.w),
                  Text(
                    'إعادة تعيين',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12.sp,
                      color: const Color(0xFF00695C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularCounter extends StatelessWidget {
  final int currentCount;
  final int target;
  final double progress;

  const _CircularCounter({
    required this.currentCount,
    required this.target,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.w,
      height: 180.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180.w,
            height: 180.w,
            child: CustomPaint(
              painter: _CircularProgressPainter(
                progress: progress,
                backgroundColor: Colors.grey.shade200,
                progressColor: const Color(0xFF00695C),
                strokeWidth: 10.w,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentCount',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'من $target',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
