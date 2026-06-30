part of 'azkar_cubit.dart';

enum AzkarStatus { initial, loading, loaded, error }

class AzkarState extends Equatable {
  final AzkarStatus status;
  final List<AzkarCategory> categories;
  final List<HisnCategory> allHisnCategories;
  final int completedToday;
  final int favoritesCount;
  final Set<int> completedIds;
  final Set<int> favoriteIds;
  final String? errorMessage;

  const AzkarState({
    this.status = AzkarStatus.initial,
    this.categories = const [],
    this.allHisnCategories = const [],
    this.completedToday = 0,
    this.favoritesCount = 0,
    this.completedIds = const {},
    this.favoriteIds = const {},
    this.errorMessage,
  });

  AzkarState copyWith({
    AzkarStatus? status,
    List<AzkarCategory>? categories,
    List<HisnCategory>? allHisnCategories,
    int? completedToday,
    int? favoritesCount,
    Set<int>? completedIds,
    Set<int>? favoriteIds,
    String? errorMessage,
  }) {
    return AzkarState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      allHisnCategories: allHisnCategories ?? this.allHisnCategories,
      completedToday: completedToday ?? this.completedToday,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      completedIds: completedIds ?? this.completedIds,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        allHisnCategories,
        completedToday,
        favoritesCount,
        completedIds,
        favoriteIds,
        errorMessage,
      ];
}

class AzkarCategory extends Equatable {
  final String id;
  final String title;
  final int count;
  final m.Color color;
  final m.IconData icon;
  final List<int> categoryIds;

  const AzkarCategory({
    required this.id,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.categoryIds,
  });

  AzkarCategory copyWith({
    String? id,
    String? title,
    int? count,
    m.Color? color,
    m.IconData? icon,
    List<int>? categoryIds,
  }) {
    return AzkarCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      count: count ?? this.count,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        count,
        color,
        icon,
        categoryIds,
      ];
}
