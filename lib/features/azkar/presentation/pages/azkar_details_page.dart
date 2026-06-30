import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/azkar_cubit.dart';
import '../../domain/entities/zikr_item.dart';
import '../../helpers/azkar_text_helper.dart';

class AzkarDetailsPage extends m.StatefulWidget {
  final String title;
  final List<int> categoryIds;
  final bool isSabahPage;

  const AzkarDetailsPage({
    super.key,
    required this.title,
    required this.categoryIds,
    this.isSabahPage = false,
  });

  @override
  m.State<AzkarDetailsPage> createState() => _AzkarDetailsPageState();
}

class _AzkarDetailsPageState extends m.State<AzkarDetailsPage> {
  late List<_ZekrProgress> _items;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AzkarCubit>();
    final state = cubit.state;
    final items = cubit.getZekrItemsForCategory(widget.categoryIds);
    _items = items.map((e) {
      final isFav = state.favoriteIds.contains(e.id);
      return _ZekrProgress(
        model: e,
        remaining: e.count,
        isFavorite: isFav,
      );
    }).toList();
  }

  void _decrement(int index) {
    setState(() {
      if (_items[index].remaining > 0) {
        final newRemaining = _items[index].remaining - 1;
        _items[index] = _items[index].copyWith(remaining: newRemaining);
        if (newRemaining == 0) {
          HapticFeedback.heavyImpact();
          context.read<AzkarCubit>().markAsCompleted(_items[index].model.id);
        }
      }
    });
  }

  void _toggleFavorite(int index) {
    final zekrId = _items[index].model.id;
    setState(() {
      _items[index] = _items[index].copyWith(
        isFavorite: !_items[index].isFavorite,
      );
    });
    context.read<AzkarCubit>().toggleFavorite(zekrId);
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Directionality(
      textDirection: m.TextDirection.rtl,
      child: m.Scaffold(
        backgroundColor: const m.Color(0xFFF9F9F9),
        body: m.SafeArea(
          child: m.Column(
            children: [
              _Header(title: widget.title),
              m.Expanded(
                child: m.ListView.builder(
                  padding: const m.EdgeInsets.fromLTRB(16, 20, 16, 32),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return _ZekrCard(
                      item: _items[index],
                      isSabahPage: widget.isSabahPage,
                      onTap: () => _decrement(index),
                      onFavTap: () => _toggleFavorite(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends m.StatelessWidget {
  final String title;

  const _Header({required this.title});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      decoration: m.BoxDecoration(
        color: const m.Color(0xFF0A7A53),
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
      padding: const m.EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: m.Column(
        children: [
          m.Row(
            mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
            children: [
              const m.SizedBox(width: 44),
              m.Text(
                title,
                style: const m.TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                  fontWeight: m.FontWeight.bold,
                  color: m.Colors.white,
                ),
              ),
              m.IconButton(
                icon: const m.Icon(m.Icons.arrow_back, color: m.Colors.white, size: 26),
                onPressed: () => m.Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZekrCard extends m.StatelessWidget {
  final _ZekrProgress item;
  final bool isSabahPage;
  final m.VoidCallback onTap;
  final m.VoidCallback onFavTap;

  const _ZekrCard({
    required this.item,
    required this.isSabahPage,
    required this.onTap,
    required this.onFavTap,
  });

  @override
  m.Widget build(m.BuildContext context) {
    final isComplete = item.remaining == 0;
    final displayText = AzkarTextHelper.getCleanedText(
      item.model.text,
      isSabah: isSabahPage,
    );

    return m.Container(
      margin: const m.EdgeInsets.only(bottom: 16),
      decoration: m.BoxDecoration(
        color: m.Colors.white,
        borderRadius: m.BorderRadius.circular(20),
        boxShadow: [
          m.BoxShadow(
            color: m.Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const m.Offset(0, 2),
          ),
        ],
      ),
      child: m.Padding(
        padding: const m.EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: m.Column(
          crossAxisAlignment: m.CrossAxisAlignment.stretch,
          children: [
            m.Row(
              crossAxisAlignment: m.CrossAxisAlignment.start,
              children: [
                m.GestureDetector(
                  onTap: onFavTap,
                  child: m.Icon(
                    item.isFavorite
                        ? m.Icons.favorite
                        : m.Icons.favorite_border,
                    color: item.isFavorite
                        ? const m.Color(0xFFFF1744)
                        : m.Colors.grey.shade400,
                    size: 24,
                  ),
                ),
              ],
            ),
            const m.SizedBox(height: 12),
            m.Text(
              displayText,
              style: m.TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                height: 1.6,
                color: isComplete
                    ? m.Colors.grey.shade400
                    : const m.Color(0xFF2D2D2D),
              ),
              textAlign: m.TextAlign.center,
              textDirection: m.TextDirection.rtl,
            ),
            const m.SizedBox(height: 16),
            m.Center(
              child: m.GestureDetector(
                onTap: isComplete ? null : onTap,
                child: m.AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: m.Curves.easeInOut,
                  width: 72,
                  height: 72,
                  decoration: m.BoxDecoration(
                    color: isComplete
                        ? const m.Color(0xFF0A7A53).withValues(alpha: 0.1)
                        : const m.Color(0xFF0A7A53),
                    shape: m.BoxShape.circle,
                    boxShadow: isComplete
                        ? []
                        : [
                            m.BoxShadow(
                              color: const m.Color(0xFF0A7A53).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const m.Offset(0, 4),
                            ),
                          ],
                  ),
                  child: isComplete
                      ? const m.Icon(
                          m.Icons.check_circle_outline,
                          color: m.Color(0xFF0A7A53),
                          size: 32,
                        )
                      : m.AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: m.Text(
                            '${item.remaining}',
                            key: m.ValueKey(item.remaining),
                            style: const m.TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 26,
                              fontWeight: m.FontWeight.bold,
                              color: m.Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZekrProgress {
  final ZikrItem model;
  final int remaining;
  final bool isFavorite;

  const _ZekrProgress({
    required this.model,
    required this.remaining,
    this.isFavorite = false,
  });

  _ZekrProgress copyWith({int? remaining, bool? isFavorite}) {
    return _ZekrProgress(
      model: model,
      remaining: remaining ?? this.remaining,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
