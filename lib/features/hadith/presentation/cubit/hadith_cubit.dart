import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/hadith_model.dart';
import '../../domain/entities/hadith_item.dart';
import '../utils/arabic_normalizer.dart';
import '../utils/book_translations.dart';
import 'hadith_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final String url;
  final String? fallbackUrl;
  final String collectionId;

  List<HadithItem> _allHadiths = const [];
  List<HadithItem> _source = const [];
  List<HadithItem> _searchResults = const [];
  Timer? _debounce;
  final Dio _dio = Dio()
    ..options.connectTimeout = const Duration(seconds: 15)
    ..options.receiveTimeout = const Duration(seconds: 30);

  Map<String, String> _rawSections = const {};
  Map<String, SectionDetail> _rawSectionDetails = const {};

  static const int pageSize = 20;

  HadithCubit({
    required this.url,
    this.fallbackUrl,
    required this.collectionId,
  }) : super(HadithState(collectionName: collectionId));

  String get _cacheKey => 'hadith_cached_$collectionId';
  String get _scrollKey => 'hadith_scroll_$collectionId';
  String get _pagesKey => 'hadith_pages_$collectionId';
  String get _bookKey => 'hadith_book_$collectionId';

  void _emitIfOpen(HadithState newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> loadInitial() async {
    _emitIfOpen(state.copyWith(status: HadithStatus.loading));
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);

      if (cachedJson != null) {
        final response = parseHadithJson(cachedJson);
        _allHadiths = response.hadiths;
        _rawSections = response.metadata.sections;
        _rawSectionDetails = response.metadata.sectionDetails;
      } else {
        await _fetchFromNetwork(prefs);
      }

      final savedBookId = prefs.getInt(_bookKey) ?? 0;
      _source = savedBookId == 0
          ? _allHadiths
          : _allHadiths.where((h) => h.bookNumber == savedBookId).toList();

      final savedPages = prefs.getInt(_pagesKey) ?? 0;
      final maxPage =
          _source.isNotEmpty ? ((_source.length - 1) ~/ pageSize) : 0;
      final restorePage = savedPages.clamp(0, maxPage);

      final end = ((restorePage + 1) * pageSize).clamp(0, _source.length);
      final items = restorePage > 0
          ? _source.sublist(0, end)
          : _source.take(pageSize).toList();

      final sections = _buildSections();

      _emitIfOpen(state.copyWith(
        status: HadithStatus.loaded,
        displayedHadiths: items,
        currentPage: restorePage,
        hasMore: items.length < _source.length,
        totalCount: _source.length,
        sections: sections,
        selectedBookId: savedBookId,
      ));
    } catch (e) {
      _emitIfOpen(state.copyWith(
        status: HadithStatus.error,
        errorMessage: 'فشل تحميل الأحاديث: $e',
      ));
    }
  }

  Future<void> _fetchFromNetwork(SharedPreferences prefs) async {
    HadithResponse response;
    try {
      response = await _tryFetch(url);
    } catch (_) {
      if (fallbackUrl != null) {
        response = await _tryFetch(fallbackUrl!);
      } else {
        rethrow;
      }
    }
    _allHadiths = response.hadiths;
    _rawSections = response.metadata.sections;
    _rawSectionDetails = response.metadata.sectionDetails;

    await prefs.setString(_cacheKey, jsonEncode({
      'metadata': {
        'name': response.metadata.name,
        'sections': response.metadata.sections,
        'section_details': response.metadata.sectionDetails.map(
          (k, v) => MapEntry(k, {
            'hadithnumber_first': v.hadithnumberFirst,
            'hadithnumber_last': v.hadithnumberLast,
          }),
        ),
      },
      'hadiths': response.hadiths
          .map((h) => {
                'hadithnumber': h.hadithnumber,
                'arabicnumber': h.arabicnumber,
                'text': h.text,
                'reference': {'book': h.bookNumber, 'hadith': h.hadithnumber},
                'grades': h.grades.map((g) => g.grade).toList(),
              })
          .toList(),
    }));
  }

  Future<HadithResponse> _tryFetch(String targetUrl) async {
    final resp = await _dio.get<dynamic>(targetUrl);
    final data = resp.data;
    if (data == null) throw Exception('فشل تحميل البيانات: استجابة فارغة');

    Map<String, dynamic> jsonData;
    if (data is Map) {
      jsonData = Map<String, dynamic>.from(data);
    } else if (data is String) {
      jsonData = json.decode(data) as Map<String, dynamic>;
    } else {
      throw Exception('تنسيق استجابة غير متوقع: ${data.runtimeType}');
    }

    return HadithResponse.fromJson(jsonData);
  }

  List<BookSection> _buildSections() {
    if (_rawSections.isEmpty && _allHadiths.isEmpty) return const [];

    if (_rawSections.isNotEmpty) {
      final details = _rawSectionDetails;
      return _rawSections.entries
          .where((e) => details.containsKey(e.key))
          .map((e) {
            final detail = details[e.key]!;
            return BookSection(
              id: int.tryParse(e.key) ?? 0,
              title: e.value,
              hadithnumberFirst: detail.hadithnumberFirst,
              hadithnumberLast: detail.hadithnumberLast,
            );
          })
          .toList(growable: false);
    }

    final seen = <int>{0};
    final sections = <BookSection>[];
    final Map<int, BookSection> sectionMap = {};

    for (final hadith in _allHadiths) {
      final bookId = hadith.bookNumber;
      if (seen.add(bookId)) {
        sectionMap[bookId] = BookSection(
          id: bookId,
          title: '',
          hadithnumberFirst: hadith.hadithnumber,
          hadithnumberLast: hadith.hadithnumber,
        );
      } else {
        final existing = sectionMap[bookId]!;
        if (hadith.hadithnumber < existing.hadithnumberFirst) {
          sectionMap[bookId] = BookSection(
            id: bookId,
            title: existing.title,
            hadithnumberFirst: hadith.hadithnumber,
            hadithnumberLast: existing.hadithnumberLast,
          );
        }
        if (hadith.hadithnumber > existing.hadithnumberLast) {
          sectionMap[bookId] = BookSection(
            id: bookId,
            title: existing.title,
            hadithnumberFirst: existing.hadithnumberFirst,
            hadithnumberLast: hadith.hadithnumber,
          );
        }
      }
    }

    final sorted = sectionMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final entry in sorted) {
      sections.add(BookSection(
        id: entry.key,
        title: '',
        hadithnumberFirst: entry.value.hadithnumberFirst,
        hadithnumberLast: entry.value.hadithnumberLast,
      ));
    }
    return sections;
  }

  void loadMoreHadiths() {
    final s = state;
    if (s.status == HadithStatus.loadingMore || !s.hasMore || s.isSearching) {
      return;
    }

    _emitIfOpen(s.copyWith(status: HadithStatus.loadingMore));

    final nextPage = s.currentPage + 1;
    final start = nextPage * pageSize;
    if (start >= _source.length) {
      _emitIfOpen(s.copyWith(status: HadithStatus.loaded, hasMore: false));
      return;
    }
    final end = (start + pageSize).clamp(0, _source.length);
    final newItems = _source.sublist(start, end);

    _emitIfOpen(s.copyWith(
      status: HadithStatus.loaded,
      displayedHadiths: [...s.displayedHadiths, ...newItems],
      currentPage: nextPage,
      hasMore: end < _source.length,
    ));
  }

  void selectBook(int bookId) {
    if (state.selectedBookId == bookId) return;
    _debounce?.cancel();

    _source = bookId == 0
        ? _allHadiths
        : _allHadiths.where((h) => h.bookNumber == bookId).toList();

    final firstPage = _source.take(pageSize).toList();
    _emitIfOpen(state.copyWith(
      status: HadithStatus.loaded,
      displayedHadiths: firstPage,
      currentPage: 0,
      hasMore: _source.length > pageSize,
      totalCount: _source.length,
      selectedBookId: bookId,
      searchQuery: '',
      isSearching: false,
    ));

    _cacheServiceSaveBook(bookId);
  }

  void search(String query) {
    _debounce?.cancel();
    _emitIfOpen(state.copyWith(
      searchQuery: query,
      isSearching: query.trim().isNotEmpty,
    ));
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (query.trim().isEmpty) {
        final firstPage = _source.take(pageSize).toList();
        _emitIfOpen(state.copyWith(
          status: HadithStatus.loaded,
          displayedHadiths: firstPage,
          currentPage: 0,
          hasMore: _source.length > pageSize,
          isSearching: false,
        ));
        return;
      }
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    try {
      final normalizedQuery = normalizeArabic(query);
      _searchResults = _source
          .where((h) => normalizeArabic(h.text).contains(normalizedQuery))
          .toList();
      _emitIfOpen(state.copyWith(
        status: HadithStatus.loaded,
        displayedHadiths: _searchResults,
        currentPage: 0,
        hasMore: false,
      ));
    } catch (e) {
      _emitIfOpen(state.copyWith(
        status: HadithStatus.error,
        errorMessage: 'خطأ في البحث: $e',
      ));
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    final firstPage = _source.take(pageSize).toList();
    _emitIfOpen(state.copyWith(
      status: HadithStatus.loaded,
      displayedHadiths: firstPage,
      currentPage: 0,
      hasMore: _source.length > pageSize,
      totalCount: _source.length,
      searchQuery: '',
      isSearching: false,
    ));
  }

  Future<void> saveScrollState(double scrollOffset) async {
    final prefs = await SharedPreferences.getInstance();
    if (scrollOffset >= 0) {
      await prefs.setDouble(_scrollKey, scrollOffset);
    }
    await prefs.setInt(_pagesKey, state.currentPage + 1);
    await prefs.setInt(_bookKey, state.selectedBookId);
  }

  Future<void> _cacheServiceSaveBook(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bookKey, bookId);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _dio.close();
    return super.close();
  }

  String translateSectionTitle(String englishTitle) {
    return translateBookTitle(englishTitle, collectionId);
  }
}
