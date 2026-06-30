import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/azkar_cubit.dart';
import '../widgets/azkar_grid_card.dart';
import 'azkar_details_page.dart';

class AllCategoriesScreen extends m.StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Directionality(
      textDirection: m.TextDirection.rtl,
      child: m.Scaffold(
        backgroundColor: const m.Color(0xFFF9F9F9),
        body: m.SafeArea(
          child: BlocBuilder<AzkarCubit, AzkarState>(
            builder: (context, state) {
              final categories = state.categories;

              return m.Column(
                children: [
                  _Header(),
                  m.Expanded(
                    child: m.Padding(
                      padding: const m.EdgeInsets.fromLTRB(16, 12, 16, 32),
                      child: m.GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.25,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: categories.map((cat) {
                          return AzkarGridCard(
                            title: cat.title,
                            subtitle: '${cat.count} ذكر',
                            color: cat.color,
                            icon: cat.icon,
                            onTap: () {
                              final cubit = context.read<AzkarCubit>();
                              final isSabah = cat.id == '1';
                              m.Navigator.push(
                                context,
                                m.MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: AzkarDetailsPage(
                                      title: cat.title,
                                      categoryIds: cat.categoryIds,
                                      isSabahPage: isSabah,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends m.StatelessWidget {
  @override
  m.Widget build(m.BuildContext context) {
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
      padding: const m.EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: m.Row(
        mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
        children: [
          const m.SizedBox(width: 44),
          const m.Text(
            'جميع الأدعية والأذكار',
            style: m.TextStyle(
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
    );
  }
}
