import 'package:flutter/material.dart';

import '../../presentation/cubit/home_state.dart';

class TealHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSettingsTap;
  final VoidCallback onDarkModeTap;
  final bool isDarkMode;

  const TealHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSettingsTap,
    required this.onDarkModeTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        gradient: HomeColors.tealGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======= Row: الأيقونات على الشمال والعنوان على اليمين =======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونات على الشمال
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onSettingsTap,
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDarkModeTap,
                    icon: Icon(
                      isDarkMode
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              // العنوان والسلام على اليمين
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
