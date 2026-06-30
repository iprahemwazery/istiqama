import 'package:flutter/material.dart';
import 'package:istiqama/core/theme/app_theme.dart';
import 'package:istiqama/features/home/presentation/pages/home_view.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72727272727275, 800.7272727272727),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'الرئيسية',
        theme: AppTheme.lightTheme,
        home: const HomeView(),
      ),
    );
  }
}
