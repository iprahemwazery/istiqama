import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/azkar_cubit.dart';
import '../widgets/azkar_header_widget.dart';
import '../widgets/azkar_grid_card.dart';
import 'azkar_details_page.dart';
import 'all_categories_screen.dart';

class AzkarPage extends m.StatelessWidget {
  const AzkarPage({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Directionality(
      textDirection: m.TextDirection.rtl,
      child: BlocProvider(
        create: (context) => AzkarCubit()..loadAzkar(),
        child: m.Scaffold(
          backgroundColor: const m.Color(0xFFF9F9F9),
          body: m.SafeArea(
            child: BlocBuilder<AzkarCubit, AzkarState>(
              builder: (context, state) {
                if (state.status == AzkarStatus.loading) {
                  return const m.Center(
                    child: m.CircularProgressIndicator(),
                  );
                }

                if (state.status == AzkarStatus.error) {
                  return m.Center(
                    child: m.Padding(
                      padding: const m.EdgeInsets.all(16),
                      child: m.Column(
                        mainAxisAlignment: m.MainAxisAlignment.center,
                        children: [
                          const m.Text(
                            'حدث خطأ في تحميل الأذكار',
                            style: m.TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                              color: m.Colors.red,
                            ),
                          ),
                          if (state.errorMessage != null) ...[
                            const m.SizedBox(height: 8),
                            m.Text(
                              state.errorMessage!,
                              style: const m.TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12,
                                color: m.Colors.grey,
                              ),
                              textAlign: m.TextAlign.center,
                            ),
                          ],
                          const m.SizedBox(height: 16),
                          m.ElevatedButton(
                            onPressed: () =>
                                context.read<AzkarCubit>().loadAzkar(),
                            child: const m.Text(
                              'إعادة المحاولة',
                              style: m.TextStyle(fontFamily: 'Tajawal'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return m.ListView(
                  padding: m.EdgeInsets.zero,
                  children: [
                    const AzkarHeaderWidget(),
                    m.Padding(
                      padding: const m.EdgeInsets.fromLTRB(16, 12, 16, 32),
                      child: m.GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.25,
                        shrinkWrap: true,
                        physics: const m.NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          ..._fixedCards(context, state),
                          _allCategoriesCard(context),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<m.Widget> _fixedCards(m.BuildContext context, AzkarState state) {
    final cardData = <_CardData>[
      _CardData(
        title: 'أذكار الصباح',
        subtitle: _itemsLabel(context, [1]),
        emoji: '🌅',
        color: const m.Color(0xFFFF9800),
        categoryIds: [1],
      ),
      _CardData(
        title: 'أذكار المساء',
        subtitle: _itemsLabel(context, [1]),
        emoji: '🌙',
        color: const m.Color(0xFF7C4DFF),
        categoryIds: [1],
      ),
      _CardData(
        title: 'أذكار النوم',
        subtitle: _itemsLabel(context, [2]),
        emoji: '😴',
        color: const m.Color(0xFF2196F3),
        categoryIds: [2],
      ),
      _CardData(
        title: 'أذكار بعد الصلاة',
        subtitle: _itemsLabel(context, [27]),
        emoji: '🕌',
        color: const m.Color(0xFF00BFA5),
        categoryIds: [27],
      ),
      _CardData(
        title: 'أدعية يومية',
        subtitle: _itemsLabel(context, [34, 35, 36, 41]),
        emoji: '🤲',
        color: const m.Color(0xFFFF1744),
        categoryIds: [34, 35, 36, 41],
      ),
      _CardData(
        title: 'آيات للحفظ',
        subtitle: _itemsLabel(context, [130]),
        emoji: '📖',
        color: const m.Color(0xFFE65100),
        categoryIds: [130],
      ),
    ];

    return cardData.map((cd) {
      return AzkarGridCard(
        title: cd.title,
        subtitle: cd.subtitle,
        color: cd.color,
        emoji: cd.emoji,
        onTap: () {
          final cubit = context.read<AzkarCubit>();
          m.Navigator.push(
            context,
            m.MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: AzkarDetailsPage(
                  title: cd.title,
                  categoryIds: cd.categoryIds,
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  m.Widget _allCategoriesCard(m.BuildContext context) {
    return m.InkWell(
      borderRadius: m.BorderRadius.circular(24),
      onTap: () {
        final cubit = context.read<AzkarCubit>();
        m.Navigator.push(
          context,
          m.MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: const AllCategoriesScreen(),
            ),
          ),
        );
      },
      child: const AzkarGridCard(
        title: 'باقي الفئات',
        subtitle: 'جميع الأدعية',
        color: m.Color(0xFF0F8A5F),
        emoji: '✨',
      ),
    );
  }

  String _itemsLabel(m.BuildContext context, List<int> ids) {
    final cubit = context.read<AzkarCubit>();
    final items = cubit.getZekrItemsForCategory(ids);
    final count = items.length;
    if (count == 0) return '0 أدعية';
    if (count == 1) return 'دعاء واحد';
    return '$count أدعية';
  }
}

class _CardData {
  final String title;
  final String subtitle;
  final String emoji;
  final m.Color color;
  final List<int> categoryIds;

  const _CardData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.categoryIds,
  });
}
