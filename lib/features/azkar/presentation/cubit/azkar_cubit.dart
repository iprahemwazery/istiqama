import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../data/datasources/azkar_local_service.dart';
import '../../domain/entities/hisn_category.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../../data/repositories/azkar_repository_impl.dart';
import '../../data/datasources/hisn_azkar_local_data_source.dart';

part 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final AzkarRepository _repository;
  final AzkarLocalService _localService;

  AzkarCubit({
    AzkarRepository? repository,
    AzkarLocalService? localService,
  })  : _repository = repository ??
            AzkarRepositoryImpl(HisnAzkarLocalDataSourceImpl()),
        _localService = localService ?? AzkarLocalService(),
        super(const AzkarState());

  void loadAzkar() async {
    emit(state.copyWith(status: AzkarStatus.loading));

    try {
      final categories = await _repository.getCategories();
      final completedCount = await _localService.loadCompletedCount();
      final completedIds = await _localService.loadCompletedIds();
      final favoriteIds = await _localService.loadFavoriteIds();

      emit(state.copyWith(
        status: AzkarStatus.loaded,
        categories: categories.map(_mapToCategory).toList(),
        allHisnCategories: categories,
        completedToday: completedCount,
        completedIds: completedIds,
        favoriteIds: favoriteIds,
        favoritesCount: favoriteIds.length,
      ));
    } catch (e, stackTrace) {
      m.debugPrint('Error loading azkar: $e\n$stackTrace');
      emit(state.copyWith(
        status: AzkarStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  AzkarCategory _mapToCategory(HisnCategory cat) {
    return AzkarCategory(
      id: cat.id.toString(),
      title: cat.title,
      count: cat.items.length,
      color: _resolveColor(cat.id),
      icon: _resolveIcon(cat.title),
      categoryIds: [cat.id],
    );
  }

  m.Color _resolveColor(int id) {
    const palette = [
      m.Color(0xFFFF9800),
      m.Color(0xFF7C4DFF),
      m.Color(0xFF2196F3),
      m.Color(0xFF00BFA5),
      m.Color(0xFFFF1744),
      m.Color(0xFFE65100),
      m.Color(0xFF1E88E5),
      m.Color(0xFF43A047),
      m.Color(0xFF8E24AA),
      m.Color(0xFFFF6F00),
    ];
    return palette[(id - 1) % palette.length];
  }

  m.IconData _resolveIcon(String title) {
    if (title.contains('صباح') || title.contains('مساء')) {
      return m.Icons.wb_sunny_outlined;
    }
    if (title.contains('نوم') || title.contains('استيقاظ')) {
      return m.Icons.bedtime_outlined;
    }
    if (title.contains('مسجد') || title.contains('صلاة') || title.contains('وضوء')) {
      return m.Icons.mosque_outlined;
    }
    if (title.contains('طعام') || title.contains('فطور') || title.contains('صائم')) {
      return m.Icons.restaurant_outlined;
    }
    if (title.contains('سفر') || title.contains('ركوب')) {
      return m.Icons.flight_takeoff_outlined;
    }
    if (title.contains('خلاء') || title.contains('خروج') || title.contains('دخول')) {
      return m.Icons.wc_outlined;
    }
    if (title.contains('ثوب') || title.contains('لبس')) {
      return m.Icons.checkroom_outlined;
    }
    if (title.contains('مريض') || title.contains('موت') || title.contains('ميت') ||
        title.contains('قبر') || title.contains('جناز') || title.contains('دفن')) {
      return m.Icons.local_hospital_outlined;
    }
    if (title.contains('مطر') || title.contains('ريح') || title.contains('رعد') ||
        title.contains('هلال')) {
      return m.Icons.water_drop_outlined;
    }
    if (title.contains('مجلس') || title.contains('كفارة')) {
      return m.Icons.groups_outlined;
    }
    if (title.contains('حج') || title.contains('عمر') || title.contains('عرفة')) {
      return m.Icons.mosque_outlined;
    }
    if (title.contains('دعاء') || title.contains('أدعية')) {
      return m.Icons.handshake_outlined;
    }
    if (title.contains('آذان') || title.contains('أذان')) {
      return m.Icons.campaign_outlined;
    }
    if (title.contains('فاتحة') || title.contains('سورة') || title.contains('آية') ||
        title.contains('قرآن')) {
      return m.Icons.menu_book_outlined;
    }
    if (title.contains('تسبيح') || title.contains('تهليل') || title.contains('تكبير')) {
      return m.Icons.repeat_outlined;
    }
    if (title.contains('سلام') || title.contains('تحية')) {
      return m.Icons.emoji_people_outlined;
    }
    if (title.contains('دعو')) {
      return m.Icons.volunteer_activism_outlined;
    }
    return m.Icons.favorite_outline;
  }

  Future<void> markAsCompleted(int zekrId) async {
    if (state.completedIds.contains(zekrId)) return;

    final updatedIds = {...state.completedIds, zekrId};
    final newCount = state.completedToday + 1;

    await _localService.saveCompletedIds(updatedIds);
    await _localService.saveCompletedCount(newCount);

    emit(state.copyWith(
      completedIds: updatedIds,
      completedToday: newCount,
    ));
  }

  Future<void> toggleFavorite(int zekrId) async {
    final updatedIds = Set<int>.from(state.favoriteIds);
    if (updatedIds.contains(zekrId)) {
      updatedIds.remove(zekrId);
    } else {
      updatedIds.add(zekrId);
    }

    await _localService.saveFavoriteIds(updatedIds);

    emit(state.copyWith(
      favoriteIds: updatedIds,
      favoritesCount: updatedIds.length,
    ));
  }

  List<HisnCategory> getCategoriesByIds(List<int> ids) {
    return state.allHisnCategories.where((c) => ids.contains(c.id)).toList();
  }

  List<dynamic> getZekrItemsForCategory(List<int> categoryIds) {
    return state.allHisnCategories
        .where((c) => categoryIds.contains(c.id))
        .expand((c) => c.items)
        .toList();
  }
}
