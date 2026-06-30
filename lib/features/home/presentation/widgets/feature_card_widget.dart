import 'package:flutter/material.dart';
import '../cubit/home_state.dart';
import '../../data/models/feature_model.dart';

class FeatureCardWidget extends StatelessWidget {
  final FeatureModel feature;
  final VoidCallback? onTap; // 1. ضيف السطر ده هنا

  const FeatureCardWidget({
    super.key,
    required this.feature,
    this.onTap, // 2. ضيفه في الـ Constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // 3. استخدام InkWell جوه الـ Container عشان الـ Ripple Effect يكون محكوم بالحواف
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20), // نفس تدويرة الكارد
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      feature.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: HomeColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: feature.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(feature.icon, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
