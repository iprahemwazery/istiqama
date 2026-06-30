import 'package:flutter/material.dart';

import '../../presentation/cubit/home_state.dart';

class TasbihButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const TasbihButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      onTap: onTap,
      title: 'المسبحة',
      subtitle: 'عداد التسبيح',
      icon: Icons.touch_app,
      iconColor: HomeColors.primaryGreen,
      isOutlined: true,
    );
  }
}

class QiblaButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  const QiblaButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      onTap: onTap,
      title: 'اتجاه القبلة',
      subtitle: 'تحديد اتجاه القبلة',
      icon: Icons.explore,
      iconColor: HomeColors.gold,
      isOutlined: false,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isOutlined;

  const _ActionButton({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isOutlined,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: HomeColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
