import 'package:flutter/material.dart' as m;
import '../../data/datasources/hisn_azkar_local_data_source.dart';
import '../../data/repositories/azkar_repository_impl.dart';
import '../../domain/entities/hisn_category.dart';
import '../../domain/repositories/azkar_repository.dart';
import 'zikr_details_screen.dart';

class CategoriesScreen extends m.StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  m.State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends m.State<CategoriesScreen> {
  final AzkarRepository _repository = AzkarRepositoryImpl(
    HisnAzkarLocalDataSourceImpl(),
  );

  List<HisnCategory>? _categories;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final categories = await _repository.getCategories();
      if (mounted) {
        setState(() => _categories = categories);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Directionality(
      textDirection: m.TextDirection.rtl,
      child: m.Scaffold(
        backgroundColor: const m.Color(0xFFF9F9F9),
        appBar: m.AppBar(
          title: const m.Text(
            'حصن المسلم',
            style: m.TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 22,
              fontWeight: m.FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const m.Color(0xFF0A7A53),
          foregroundColor: m.Colors.white,
          elevation: 0,
        ),
        body: _buildBody(),
      ),
    );
  }

  m.Widget _buildBody() {
    if (_error != null) {
      return m.Center(
        child: m.Padding(
          padding: const m.EdgeInsets.all(24),
          child: m.Text(
            'تعذر التحميل: $_error',
            style: const m.TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              color: m.Color(0xFF757575),
            ),
            textAlign: m.TextAlign.center,
          ),
        ),
      );
    }

    final categories = _categories;
    if (categories == null) {
      return const m.Center(child: m.CircularProgressIndicator());
    }

    return m.ListView.builder(
      padding: const m.EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return _CategoryCard(
          id: cat.id,
          title: cat.title,
          itemCount: cat.items.length,
          onTap: () {
            m.Navigator.push(
              context,
              m.MaterialPageRoute(
                builder: (_) => ZikrDetailsScreen(category: cat),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends m.StatelessWidget {
  final int id;
  final String title;
  final int itemCount;
  final m.VoidCallback onTap;

  const _CategoryCard({
    required this.id,
    required this.title,
    required this.itemCount,
    required this.onTap,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.Padding(
      padding: const m.EdgeInsets.only(bottom: 12),
      child: m.GestureDetector(
        onTap: onTap,
        child: m.Container(
          padding: const m.EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(16),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const m.Offset(0, 2),
              ),
            ],
          ),
          child: m.Row(
            children: [
              _CategoryIcon(id: id),
              const m.SizedBox(width: 16),
              m.Expanded(
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    m.Text(
                      title,
                      style: const m.TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: m.FontWeight.bold,
                        color: m.Color(0xFF2D2D2D),
                      ),
                    ),
                    const m.SizedBox(height: 4),
                    m.Text(
                      '$itemCount ذكر',
                      style: m.TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: m.Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              m.Icon(
                m.Icons.arrow_forward_ios_rounded,
                size: 18,
                color: m.Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends m.StatelessWidget {
  final int id;

  const _CategoryIcon({required this.id});

  @override
  m.Widget build(m.BuildContext context) {
    final icon = _resolveIcon();
    return m.Container(
      width: 48,
      height: 48,
      decoration: m.BoxDecoration(
        color: icon.color.withValues(alpha: 0.12),
        borderRadius: m.BorderRadius.circular(14),
      ),
      child: m.Icon(icon.iconData, color: icon.color, size: 24),
    );
  }

  _IconData _resolveIcon() {
    switch (id) {
      case 1:
        return const _IconData(m.Icons.wb_sunny_outlined, m.Color(0xFFFF9800));
      case 2:
        return const _IconData(m.Icons.bedtime_outlined, m.Color(0xFF2196F3));
      case 27:
        return const _IconData(m.Icons.mosque_outlined, m.Color(0xFF00BFA5));
      case 4:
      case 5:
      case 8:
      case 9:
      case 69:
      case 70:
        return const _IconData(m.Icons.handshake_outlined, m.Color(0xFFFF1744));
      case 3:
      case 23:
        return const _IconData(m.Icons.menu_book_outlined, m.Color(0xFFE65100));
      default:
        return const _IconData(m.Icons.favorite_outline, m.Color(0xFF7C4DFF));
    }
  }
}

class _IconData {
  final m.IconData iconData;
  final m.Color color;

  const _IconData(this.iconData, this.color);
}
