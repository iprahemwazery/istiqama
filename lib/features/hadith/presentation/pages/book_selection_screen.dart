import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/hadith_cubit.dart';
import 'main_hadiths_page.dart';

class BookSelectionScreen extends StatelessWidget {
  const BookSelectionScreen({super.key});

  static const _collections = [
    (
      id: 'bukhari',
      name: 'صحيح البخاري',
      subtitle: 'أشهر كتب الحديث النبوي',
      url:
          'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/ara-bukhari.json',
      fallback:
          'https://raw.githubusercontent.com/fawazahmed0/hadith-api/refs/heads/1/editions/ara-bukhari.json',
      icon: Icons.auto_stories,
      hadithCount: 'أكثر من ٧٥٠٠ حديث',
      color: Color(0xFF075E54),
    ),
    (
      id: 'tirmidhi',
      name: 'جامع الترمذي',
      subtitle: 'من كتب السنة الستة',
      url:
          'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/ara-tirmidhi.json',
      fallback:
          'https://raw.githubusercontent.com/fawazahmed0/hadith-api/refs/heads/1/editions/ara-tirmidhi.json',
      icon: Icons.menu_book_rounded,
      hadithCount: 'أكثر من ٣٩٠٠ حديث',
      color: Color(0xFFC7A44D),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر الموسوعة الحديثية'),
          centerTitle: true,
          backgroundColor: const Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F5F5), Colors.white],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Text(
                  'اختر أحد كتب الحديث لبدء القراءة',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: const Color(0xFF1A2E3B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'تصفح وابحث في أشهر موسوعات الحديث النبوي',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 32.h),
                Expanded(
                  child: ListView.separated(
                    itemCount: _collections.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (context, index) {
                      final c = _collections[index];
                      return _CollectionCard(
                        name: c.name,
                        subtitle: c.subtitle,
                        hadithCount: c.hadithCount,
                        icon: c.icon,
                        color: c.color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => HadithCubit(
                                  url: c.url,
                                  fallbackUrl: c.fallback,
                                  collectionId: c.id,
                                ),
                                child: MainHadithsPage(
                                  title: c.name,
                                  collectionId: c.id,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String hadithCount;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CollectionCard({
    required this.name,
    required this.subtitle,
    required this.hadithCount,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        splashColor: color.withValues(alpha: 0.1),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9F6),
            borderRadius: BorderRadius.circular(20.r),
            border: Border(
              right: BorderSide(
                color: color.withValues(alpha: 0.5),
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(icon, color: color, size: 30.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2E3B),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        hadithCount,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black26,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
