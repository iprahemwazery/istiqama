import 'package:flutter/material.dart' as m;

class AzkarGridCard extends m.StatelessWidget {
  final String title;
  final String subtitle;
  final m.Color color;
  final String? emoji;
  final m.IconData? icon;
  final m.VoidCallback? onTap;

  const AzkarGridCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    this.emoji,
    this.icon,
    this.onTap,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.GestureDetector(
      onTap: onTap,
      child: m.Container(
        decoration: m.BoxDecoration(
          borderRadius: m.BorderRadius.circular(24),
          boxShadow: [
            m.BoxShadow(
              color: m.Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const m.Offset(0, 4),
            ),
          ],
        ),
        child: m.ClipRRect(
          borderRadius: m.BorderRadius.circular(24),
          child: m.Stack(
            children: [
              m.Container(
                decoration: m.BoxDecoration(
                  gradient: m.LinearGradient(
                    begin: m.Alignment.topCenter,
                    end: m.Alignment.bottomCenter,
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              m.Positioned(
                top: 16,
                left: 16,
                child: m.Container(
                  width: 44,
                  height: 44,
                  decoration: m.BoxDecoration(
                    color: m.Colors.white.withValues(alpha: 0.2),
                    borderRadius: m.BorderRadius.circular(14),
                  ),
                  child: emoji != null
                      ? m.Text(
                          emoji!,
                          textAlign: m.TextAlign.center,
                          style: const m.TextStyle(fontSize: 22),
                        )
                      : m.Icon(icon, color: m.Colors.white, size: 22),
                ),
              ),
              m.Positioned(
                bottom: 16,
                right: 16,
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.end,
                  children: [
                    m.Text(
                      title,
                      style: const m.TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: m.FontWeight.bold,
                        color: m.Colors.white,
                      ),
                    ),
                    const m.SizedBox(height: 4),
                    m.Text(
                      subtitle,
                      style: m.TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: m.Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              m.Positioned(
                left: 12,
                bottom: 16,
                child: m.Icon(
                  m.Icons.arrow_back_ios,
                  color: m.Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
