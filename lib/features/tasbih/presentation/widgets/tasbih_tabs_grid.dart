import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/phrase_entity.dart';

class TasbihTabsGrid extends StatelessWidget {
  final List<PhraseEntity> phrases;
  final String activePhraseId;
  final void Function(String) onPhraseTap;

  const TasbihTabsGrid({
    super.key,
    required this.phrases,
    required this.activePhraseId,
    required this.onPhraseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 2.6,
        ),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final phrase = phrases[index];
          final isActive = phrase.id == activePhraseId;
          return _PhraseTabCard(
            phrase: phrase,
            isActive: isActive,
            onTap: () => onPhraseTap(phrase.id),
          );
        },
      ),
    );
  }
}

class _PhraseTabCard extends StatelessWidget {
  final PhraseEntity phrase;
  final bool isActive;
  final VoidCallback onTap;

  const _PhraseTabCard({
    required this.phrase,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00695C) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive ? const Color(0xFF00695C) : Colors.grey.shade200,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF00695C).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phrase.text,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF212121),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6.r,
              height: 6.r,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
