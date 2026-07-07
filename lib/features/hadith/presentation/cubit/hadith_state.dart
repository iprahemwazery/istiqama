import 'package:equatable/equatable.dart';

import '../../data/models/hadith_model.dart';
import '../../domain/entities/hadith_item.dart';

enum HadithStatus { initial, loading, loaded, loadingMore, error }

class HadithState extends Equatable {
  final HadithStatus status;
  final List<HadithItem> displayedHadiths;
  final String? errorMessage;
  final String searchQuery;
  final int currentPage;
  final bool hasMore;
  final int totalCount;
  final bool isSearching;
  final List<BookSection> sections;
  final int selectedBookId;
  final String collectionName;

  const HadithState({
    this.status = HadithStatus.initial,
    this.displayedHadiths = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.currentPage = 0,
    this.hasMore = true,
    this.totalCount = 0,
    this.isSearching = false,
    this.sections = const [],
    this.selectedBookId = 0,
    this.collectionName = '',
  });

  HadithState copyWith({
    HadithStatus? status,
    List<HadithItem>? displayedHadiths,
    String? errorMessage,
    String? searchQuery,
    int? currentPage,
    bool? hasMore,
    int? totalCount,
    bool? isSearching,
    List<BookSection>? sections,
    int? selectedBookId,
    String? collectionName,
  }) {
    return HadithState(
      status: status ?? this.status,
      displayedHadiths: displayedHadiths ?? this.displayedHadiths,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      isSearching: isSearching ?? this.isSearching,
      sections: sections ?? this.sections,
      selectedBookId: selectedBookId ?? this.selectedBookId,
      collectionName: collectionName ?? this.collectionName,
    );
  }

  @override
  List<Object?> get props => [
        status,
        displayedHadiths,
        errorMessage,
        searchQuery,
        currentPage,
        hasMore,
        totalCount,
        isSearching,
        sections,
        selectedBookId,
        collectionName,
      ];
}
