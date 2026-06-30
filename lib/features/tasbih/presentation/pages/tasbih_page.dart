import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/tasbih_cubit.dart';
import '../widgets/tasbih_tabs_grid.dart';
import '../widgets/counter_card.dart';
import '../widgets/hadith_card.dart';

class TasbihPage extends StatelessWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => TasbihCubit()..loadPhrases(),
          child: BlocBuilder<TasbihCubit, TasbihState>(
            builder: (context, state) {
              final activePhrase = state.activePhrase;

              return Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      Color(0xFF1B5E20),
                      Color(0xFF0A0A0A),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.h),
                        _AppBar(),
                        SizedBox(height: 24.h),
                        if (state.phrases.isNotEmpty)
                          TasbihTabsGrid(
                            phrases: state.phrases,
                            activePhraseId: state.activePhraseId,
                            onPhraseTap: (id) =>
                                context.read<TasbihCubit>().selectPhrase(id),
                          ),
                        SizedBox(height: 24.h),
                        if (activePhrase != null)
                          CounterCard(
                            activePhrase: activePhrase,
                            totalToday: state.totalToday,
                            rounds: state.rounds,
                            onIncrement: () =>
                                context.read<TasbihCubit>().incrementCount(),
                            onReset: () =>
                                context.read<TasbihCubit>().resetCounter(),
                          ),
                        const HadithCard(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 26.r),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'المسبحة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
