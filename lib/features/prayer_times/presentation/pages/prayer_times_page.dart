import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/prayer_times_cubit.dart';
import '../widgets/prayer_header_widget.dart';
import '../widgets/prayer_list_widget.dart';

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => PrayerTimesCubit()..loadPrayerTimes(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                const PrayerHeaderWidget(),
                Expanded(
                  child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                    builder: (context, state) {
                      return PrayerListWidget(
                        prayerTimes: state.prayerTimes,
                        onNotificationToggle: (index) =>
                            context.read<PrayerTimesCubit>().toggleNotification(index),
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
