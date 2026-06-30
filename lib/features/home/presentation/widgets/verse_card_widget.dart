import 'package:flutter/material.dart';

import '../../presentation/cubit/home_state.dart';
import '../../data/models/verse_model.dart';

class VerseCardWidget extends StatelessWidget {
  final VerseModel verse;

  const VerseCardWidget({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: BoxDecoration(
        color: HomeColors.cream,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: HomeColors.gold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33D4A24C),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            verse.title,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Container(width: 40, height: 1, color: Colors.black26),
          const SizedBox(height: 16),
          Text(
            verse.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HomeColors.primaryGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 40, height: 1, color: Colors.black26),
          const SizedBox(height: 10),
          Text(
            verse.surahName,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
