import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart' show HapticFeedback;
import '../../domain/entities/hisn_category.dart';

class ZikrDetailsScreen extends m.StatefulWidget {
  final HisnCategory category;

  const ZikrDetailsScreen({super.key, required this.category});

  @override
  m.State<ZikrDetailsScreen> createState() => _ZikrDetailsScreenState();
}

class _ZikrDetailsScreenState extends m.State<ZikrDetailsScreen> {
  late List<_ZikrProgress> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.category.items.map((e) {
      return _ZikrProgress(
        id: e.id,
        text: e.text,
        total: e.count,
        remaining: e.count,
      );
    }).toList();
  }

  void _decrement(int index) {
    setState(() {
      if (_items[index].remaining > 0) {
        _items[index] = _items[index].copyWith(
          remaining: _items[index].remaining - 1,
        );
        if (_items[index].remaining == 0) {
          HapticFeedback.heavyImpact();
        }
      }
    });
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
              _Header(title: widget.category.title),
              m.Expanded(
                child: m.ListView.builder(
                  padding: const m.EdgeInsets.fromLTRB(16, 20, 16, 32),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return _ZikrCard(
                      item: _items[index],
                      onTap: () => _decrement(index),
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
                icon: const m.Icon(
                  m.Icons.arrow_back,
                  color: m.Colors.white,
                  size: 26,
                ),
                onPressed: () => m.Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZikrCard extends m.StatelessWidget {
  final _ZikrProgress item;
  final m.VoidCallback onTap;

  const _ZikrCard({required this.item, required this.onTap});

  @override
  m.Widget build(m.BuildContext context) {
    final isComplete = item.remaining == 0;

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
            m.Text(
              item.text,
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
                              color: const m.Color(0xFF0A7A53)
                                  .withValues(alpha: 0.3),
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

class _ZikrProgress {
  final int id;
  final String text;
  final int total;
  final int remaining;

  const _ZikrProgress({
    required this.id,
    required this.text,
    required this.total,
    required this.remaining,
  });

  _ZikrProgress copyWith({int? remaining}) {
    return _ZikrProgress(
      id: id,
      text: text,
      total: total,
      remaining: remaining ?? this.remaining,
    );
  }
}
