import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/dream_ai_cubit.dart';
import '../cubit/dream_ai_state.dart';

class DreamAiColors {
  static const Color primaryTeal = Color(0xFF00695C);
  static const Color emeraldGreen = Color(0xFF0D7E5E);
  static const Color gold = Color(0xFFD4A24C);
  static const Color offWhite = Color(0xFFFAF9F6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static LinearGradient get buttonGradient => const LinearGradient(
    colors: [Color(0xFF0D7E5E), Color(0xFF00695C)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class DreamAiPage extends StatelessWidget {
  const DreamAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DreamAiCubit(),
      child: const _DreamAiView(),
    );
  }
}

class _DreamAiView extends StatefulWidget {
  const _DreamAiView();

  @override
  State<_DreamAiView> createState() => _DreamAiViewState();
}

class _DreamAiViewState extends State<_DreamAiView> {
  final _dreamController = TextEditingController();

  @override
  void dispose() {
    _dreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DreamAiColors.background,
        appBar: AppBar(
          title: const Text(
            'تفسير الأحلام',
            style: TextStyle(
              fontFamily: 'Taha',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: DreamAiColors.primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<DreamAiCubit, DreamAiState>(
          listener: (context, state) {
            if (state.status == DreamAiStatus.error && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<DreamAiCubit>();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  _buildDreamInput(cubit),
                  SizedBox(height: 16.h),
                  _buildInterpretButton(cubit, state),
                  SizedBox(height: 24.h),
                  if (state.status == DreamAiStatus.loading)
                    _buildShimmerLoading()
                  else if (state.status == DreamAiStatus.loaded)
                    _buildResultCard(state)
                  else if (state.status == DreamAiStatus.initial)
                    _buildInitialPlaceholder(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.auto_stories,
          size: 48.r,
          color: DreamAiColors.gold,
        ),
        SizedBox(height: 8.h),
        Text(
          'اسْتَخِيرُوا اللَّهَ فِي الْأُمُورِ كُلِّهَا',
          style: TextStyle(
            fontFamily: 'Taha',
            fontSize: 16.sp,
            color: DreamAiColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDreamInput(DreamAiCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        color: DreamAiColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _dreamController,
        onChanged: cubit.updateDreamDescription,
        maxLines: 5,
        minLines: 5,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'Taha',
          fontSize: 16.sp,
          color: DreamAiColors.textPrimary,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: 'اكتب هنا وصف الحلم الذي رأيته...',
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(
            fontFamily: 'Taha',
            fontSize: 16.sp,
            color: DreamAiColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: DreamAiColors.surface,
          contentPadding: EdgeInsets.all(16.r),
        ),
      ),
    );
  }

  Widget _buildInterpretButton(DreamAiCubit cubit, DreamAiState state) {
    final isLoading = state.status == DreamAiStatus.loading;

    return SizedBox(
      height: 52.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: DreamAiColors.buttonGradient,
          boxShadow: [
            BoxShadow(
              color: DreamAiColors.emeraldGreen.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: MaterialButton(
          onPressed: isLoading ? null : cubit.interpretDream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: isLoading
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_stories, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'فسّر حلمي',
                      style: TextStyle(
                        fontFamily: 'Taha',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildResultCard(DreamAiState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: DreamAiColors.offWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: DreamAiColors.emeraldGreen,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: DreamAiColors.emeraldGreen.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, color: DreamAiColors.gold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'التفسير',
                style: TextStyle(
                  fontFamily: 'Taha',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: DreamAiColors.emeraldGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 1,
            color: DreamAiColors.emeraldGreen.withValues(alpha: 0.2),
          ),
          SizedBox(height: 12.h),
          Text(
            state.interpretation,
            style: TextStyle(
              fontFamily: 'Taha',
              fontSize: 18.sp,
              color: DreamAiColors.textPrimary,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: DreamAiColors.offWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: DreamAiColors.gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.nightlight_round,
            size: 40.r,
            color: DreamAiColors.gold.withValues(alpha: 0.6),
          ),
          SizedBox(height: 12.h),
          Text(
            'صِف حلمك بالتفصيل ليتم تفسيره بناءً على كتاب ابن سيرين والنابلسي',
            style: TextStyle(
              fontFamily: 'Taha',
              fontSize: 15.sp,
              color: DreamAiColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
