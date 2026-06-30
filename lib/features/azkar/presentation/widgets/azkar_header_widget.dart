import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/azkar_cubit.dart';

class AzkarHeaderWidget extends m.StatelessWidget {
  const AzkarHeaderWidget({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        return m.Container(
          decoration: m.BoxDecoration(
            color: const m.Color(0xFF0F8A5F),
            borderRadius: const m.BorderRadius.only(
              bottomLeft: m.Radius.circular(45),
              bottomRight: m.Radius.circular(45),
            ),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const m.Offset(0, 4),
              ),
            ],
          ),
          padding: const m.EdgeInsets.fromLTRB(20, 50, 20, 30),
          child: m.Column(
            children: [
              _TopBar(),
              const m.SizedBox(height: 16),
              _TitleSection(),
              const m.SizedBox(height: 28),
              _CountersRow(state: state),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends m.StatelessWidget {
  @override
  m.Widget build(m.BuildContext context) {
    return m.Row(
      mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
      children: [
        m.IconButton(
          icon: const m.Icon(m.Icons.arrow_back, color: m.Colors.white, size: 26),
          onPressed: () => m.Navigator.pop(context),
        ),
        m.Container(
          width: 44,
          height: 44,
          decoration: m.BoxDecoration(
            color: m.Colors.white.withValues(alpha: 0.15),
            borderRadius: m.BorderRadius.circular(22),
          ),
          child: const m.Text(
            '☀️',
            textAlign: m.TextAlign.center,
            style: m.TextStyle(fontSize: 22),
          ),
        ),
      ],
    );
  }
}

class _TitleSection extends m.StatelessWidget {
  @override
  m.Widget build(m.BuildContext context) {
    return m.Column(
      children: [
        const m.Text(
          'الأدعية والأذكار',
          style: m.TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 24,
            fontWeight: m.FontWeight.bold,
            color: m.Colors.white,
          ),
          textAlign: m.TextAlign.center,
        ),
        const m.SizedBox(height: 8),
        m.Text(
          'حصن المسلم اليومي',
          style: m.TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            color: m.Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: m.TextAlign.center,
        ),
      ],
    );
  }
}

class _CountersRow extends m.StatelessWidget {
  final AzkarState state;

  const _CountersRow({required this.state});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Row(
      children: [
        _CounterCard(label: 'الفئات', value: '${state.categories.length}'),
        const m.SizedBox(width: 12),
        _CounterCard(label: 'مكتملة اليوم', value: '${state.completedToday}'),
        const m.SizedBox(width: 12),
        _CounterCard(label: 'المفضلة', value: '${state.favoritesCount}'),
      ],
    );
  }
}

class _CounterCard extends m.StatelessWidget {
  final String label;
  final String value;

  const _CounterCard({required this.label, required this.value});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Expanded(
      child: m.Container(
        padding: const m.EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: m.BoxDecoration(
          color: m.Colors.white.withValues(alpha: 0.12),
          borderRadius: m.BorderRadius.circular(20),
        ),
        child: m.Column(
          children: [
            m.Text(
              label,
              style: m.TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: m.Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: m.TextAlign.center,
              maxLines: 1,
              overflow: m.TextOverflow.ellipsis,
            ),
            const m.SizedBox(height: 6),
            m.Text(
              value,
              style: const m.TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 24,
                fontWeight: m.FontWeight.bold,
                color: m.Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
