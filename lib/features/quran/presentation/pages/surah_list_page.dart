import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:istiqama/features/quran/presentation/pages/quran_reader_page.dart';
import 'package:quran/quran.dart';

class QuranPage extends StatefulWidget {
  final dynamic suraJsonData;

  const QuranPage({super.key, required this.suraJsonData});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String _searchQuery = '';
  int _selectedTabIndex = 0;
  bool isSearchByVerse = false;
  List<dynamic> ayatFilteredResults = [];

  late List _allData;
  late List _filteredData;

  int _meccanCount = 0;
  int _medinanCount = 0;

  @override
  void initState() {
    super.initState();
    _allData = List.from(widget.suraJsonData);
    _filteredData = List.from(widget.suraJsonData);
    for (final surah in _allData) {
      if (surah['revelationType'] == 'Meccan') {
        _meccanCount++;
      } else {
        _medinanCount++;
      }
    }
  }

  void _onToggleSearchMode() {
    setState(() {
      isSearchByVerse = !isSearchByVerse;
      _searchController.clear();
      _searchQuery = '';
      ayatFilteredResults = [];
      _filteredData = List.from(_allData);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (isSearchByVerse) {
        if (query.trim().isNotEmpty) {
          final result = searchWords(query.trim());
          ayatFilteredResults = result['result'] as List<dynamic>;
        } else {
          ayatFilteredResults = [];
        }
      } else {
        _applyFilters();
      }
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredData = _allData.where((surah) {
      if (_selectedTabIndex == 1 && surah['revelationType'] != 'Meccan') {
        return false;
      }
      if (_selectedTabIndex == 2 && surah['revelationType'] != 'Medinan') {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final englishName = surah['englishName'].toString().toLowerCase();
        final arabicName = surah['name'].toString();
        final query = _searchQuery.toLowerCase();
        return englishName.contains(query) || arabicName.contains(query);
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      backgroundColor: const m.Color(0xFFF5F7FA),
      body: m.SafeArea(
        child: m.Directionality(
          textDirection: m.TextDirection.rtl,
          child: m.Column(
            children: [
              _QuranHeaderWidget(
                searchController: _searchController,
                searchFocus: _searchFocus,
                onSearchChanged: _onSearchChanged,
                isSearchByVerse: isSearchByVerse,
                onToggleSearchMode: _onToggleSearchMode,
              ),
              if (!isSearchByVerse || _searchQuery.trim().isEmpty) ...[
                _QuranFilterTabs(
                  selectedIndex: _selectedTabIndex,
                  meccanCount: _meccanCount,
                  medinanCount: _medinanCount,
                  onTabSelected: _onTabSelected,
                ),
                const _SurahStatsRow(),
              ],
              m.Expanded(
                child: isSearchByVerse && _searchQuery.trim().isNotEmpty
                    ? _VerseSearchResults(
                        results: ayatFilteredResults,
                        suraJsonData: widget.suraJsonData,
                      )
                    : _SurahList(
                        surahList: _filteredData,
                        suraJsonData: widget.suraJsonData,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuranHeaderWidget extends m.StatelessWidget {
  final TextEditingController searchController;
  final FocusNode searchFocus;
  final ValueChanged<String> onSearchChanged;
  final bool isSearchByVerse;
  final VoidCallback onToggleSearchMode;

  const _QuranHeaderWidget({
    required this.searchController,
    required this.searchFocus,
    required this.onSearchChanged,
    required this.isSearchByVerse,
    required this.onToggleSearchMode,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      padding: m.EdgeInsets.only(
        top: 24.h,
        left: 20.w,
        right: 20.w,
        bottom: 26.h,
      ),
      decoration: m.BoxDecoration(
        color: const m.Color(0xFF0F8056),
        borderRadius: m.BorderRadius.only(
          bottomLeft: m.Radius.circular(30.r),
          bottomRight: m.Radius.circular(30.r),
        ),
      ),
      child: m.Column(
        children: [
          m.Row(
            children: [
              m.IconButton(
                onPressed: () => m.Navigator.pop(context),
                icon: m.Icon(
                  m.Icons.arrow_back_ios,
                  color: m.Colors.white,
                  size: 20.r,
                ),
                padding: m.EdgeInsets.zero,
                constraints: m.BoxConstraints(minWidth: 32.w, minHeight: 32.h),
              ),
              const m.Spacer(),
              m.Text(
                'القرآن الكريم',
                style: m.TextStyle(
                  color: m.Colors.white,
                  fontSize: 20.sp,
                  fontWeight: m.FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const m.Spacer(),
              m.SizedBox(width: 32.w),
            ],
          ),
          m.SizedBox(height: 6.h),
          m.Text(
            '114 سورة',
            style: m.TextStyle(
              color: m.Colors.white.withValues(alpha: 0.85),
              fontSize: 14.sp,
              fontWeight: m.FontWeight.w500,
            ),
          ),
          m.SizedBox(height: 18.h),
          m.Container(
            height: 48.h,
            decoration: m.BoxDecoration(
              color: m.Colors.white,
              borderRadius: m.BorderRadius.circular(26.r),
              boxShadow: [
                m.BoxShadow(
                  color: m.Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const m.Offset(0, 4),
                ),
              ],
            ),
            child: m.TextField(
              controller: searchController,
              focusNode: searchFocus,
              onChanged: onSearchChanged,
              textDirection: m.TextDirection.rtl,
              style: m.TextStyle(
                fontSize: 15.sp,
                color: const m.Color(0xFF2D3142),
              ),
              decoration: m.InputDecoration(
                hintText: isSearchByVerse
                    ? 'ابحث عن آية...'
                    : 'ابحث عن سورة...',
                hintTextDirection: m.TextDirection.rtl,
                hintStyle: m.TextStyle(
                  color: const m.Color(0xFFB0B0B0),
                  fontSize: 15.sp,
                ),
                suffixIcon: m.IconButton(
                  onPressed: onToggleSearchMode,
                  icon: m.Icon(
                    isSearchByVerse ? m.Icons.text_fields : m.Icons.swap_horiz,
                    color: const m.Color(0xFF0F8056),
                    size: 20.r,
                  ),
                ),
                border: m.InputBorder.none,
                contentPadding: m.EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final int meccanCount;
  final int medinanCount;
  final ValueChanged<int> onTabSelected;

  const _QuranFilterTabs({
    required this.selectedIndex,
    required this.meccanCount,
    required this.medinanCount,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['الكل', 'مكية $meccanCount', 'مدنية $medinanCount'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  height: 42.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F8056) : Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: const Color(0xFFD0D5DD),
                            width: 1.2,
                          ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF0F8056,
                              ).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF2D3142),
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SurahStatsRow extends StatelessWidget {
  const _SurahStatsRow();

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'label': '114 سورة',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF2E7D32),
      },
      {
        'label': '6236 آية',
        'icon': Icons.auto_stories_rounded,
        'color': const Color(0xFFFEF3E8),
        'iconColor': const Color(0xFFE65100),
      },
      {
        'label': '604 صفحة',
        'icon': Icons.description_rounded,
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF1565C0),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: List.generate(stats.length, (index) {
          final stat = stats[index];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: stat['color'] as Color,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      size: 18.r,
                      color: stat['iconColor'] as Color,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        stat['label'] as String,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3142),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SurahList extends StatelessWidget {
  final List surahList;
  final dynamic suraJsonData;

  const _SurahList({required this.surahList, required this.suraJsonData});

  @override
  Widget build(BuildContext context) {
    if (surahList.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.r,
              color: const Color(0xFFB0B0B0),
            ),
            SizedBox(height: 8.h),
            Text(
              'لا توجد نتائج للبحث',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9E9E9E)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h, bottom: 24.h),
      physics: const BouncingScrollPhysics(),
      itemCount: surahList.length,
      itemBuilder: (context, index) {
        final surah = surahList[index];
        final suraNumber = surah['number'] as int;
        final ayahCount = getVerseCount(suraNumber);

        return _SurahListItem(
          surah: surah,
          index: index,
          suraNumber: suraNumber,
          ayahCount: ayahCount,
          suraJsonData: suraJsonData,
        );
      },
    );
  }
}

class _SurahListItem extends m.StatelessWidget {
  final dynamic surah;
  final int index;
  final int suraNumber;
  final int ayahCount;
  final dynamic suraJsonData;

  const _SurahListItem({
    required this.surah,
    required this.index,
    required this.suraNumber,
    required this.ayahCount,
    required this.suraJsonData,
  });

  @override
  m.Widget build(m.BuildContext context) {
    final isMeccan = surah['revelationType'] == 'Meccan';

    return m.Padding(
      padding: m.EdgeInsets.only(bottom: 12.h),
      child: m.GestureDetector(
        onTap: () {
          m.Navigator.push(
            context,
            m.MaterialPageRoute(
              builder: (_) => QuranViewPage(
                jsonData: suraJsonData,
                pageNumber: getPageNumber(suraNumber, 1),
                shouldHighlightText: false,
                highlightVerse: '',
              ),
            ),
          );
        },
        child: m.Container(
          padding: m.EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: m.BoxDecoration(
            color: m.Colors.white,
            borderRadius: m.BorderRadius.circular(16.r),
            boxShadow: [
              m.BoxShadow(
                color: m.Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const m.Offset(0, 4),
              ),
            ],
          ),
          child: m.Row(
            children: [
              _SurahNumberBadge(number: suraNumber),
              m.SizedBox(width: 14.w),
              m.Expanded(
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    m.Text(
                      surah['name'] ?? '',
                      style: m.TextStyle(
                        fontFamily: 'arsura',
                        fontSize: 18.sp,
                        fontWeight: m.FontWeight.bold,
                        color: const m.Color(0xFF1A1D2E),
                        height: 1.2,
                      ),
                    ),
                    m.SizedBox(height: 4.h),
                    m.Text(
                      '${surah['englishName'] ?? ''} \u2022 آية $ayahCount',
                      style: m.TextStyle(
                        fontSize: 13.sp,
                        fontWeight: m.FontWeight.w500,
                        color: const m.Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              m.SizedBox(width: 8.w),
              _RevelationBadge(isMeccan: isMeccan),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahNumberBadge extends m.StatelessWidget {
  final int number;

  const _SurahNumberBadge({required this.number});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      width: 48.r,
      height: 48.r,
      alignment: m.Alignment.center,
      decoration: m.BoxDecoration(
        color: const m.Color(0xFF0F8056).withValues(alpha: 0.08),
        borderRadius: m.BorderRadius.circular(12.r),
      ),
      child: m.Stack(
        alignment: m.Alignment.center,
        children: [
          m.Icon(
            m.Icons.star_border_rounded,
            size: 34.r,
            color: const m.Color(0xFF0F8056).withValues(alpha: 0.2),
          ),
          m.Text(
            number.toString(),
            style: m.TextStyle(
              fontSize: 14.sp,
              fontWeight: m.FontWeight.w800,
              color: const m.Color(0xFF0F8056),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseSearchResults extends m.StatelessWidget {
  final List<dynamic> results;
  final dynamic suraJsonData;

  const _VerseSearchResults({
    required this.results,
    required this.suraJsonData,
  });

  @override
  m.Widget build(m.BuildContext context) {
    if (results.isEmpty) {
      return m.Center(
        child: m.Column(
          mainAxisSize: m.MainAxisSize.min,
          children: [
            m.Icon(
              m.Icons.search_off_rounded,
              size: 48.r,
              color: const m.Color(0xFFB0B0B0),
            ),
            m.SizedBox(height: 8.h),
            m.Text(
              'لا توجد نتائج للبحث',
              style: m.TextStyle(
                fontSize: 14.sp,
                color: const m.Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      );
    }

    return m.ListView.builder(
      padding: m.EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: 24.h,
      ),
      physics: const m.BouncingScrollPhysics(),
      itemCount: results.length > 50 ? 50 : results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final surahNumber = item['surah'] as int;
        final verseNumber = item['verse'] as int;
        final surahNameArabic = getSurahNameArabic(surahNumber);
        final verseText = getVerse(
          surahNumber,
          verseNumber,
          verseEndSymbol: true,
        );

        return m.Padding(
          padding: m.EdgeInsets.only(bottom: 10.h),
          child: m.GestureDetector(
            onTap: () {
              final page = getPageNumber(surahNumber, verseNumber);
              m.Navigator.push(
                context,
                m.MaterialPageRoute(
                  builder: (_) => QuranViewPage(
                    jsonData: suraJsonData,
                    pageNumber: page,
                    shouldHighlightText: true,
                    highlightVerse: verseNumber.toString(),
                  ),
                ),
              );
            },
            child: m.Container(
              padding: m.EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: m.BoxDecoration(
                color: m.Colors.white,
                borderRadius: m.BorderRadius.circular(16.r),
                boxShadow: [
                  m.BoxShadow(
                    color: m.Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const m.Offset(0, 3),
                  ),
                ],
              ),
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  m.Text(
                    'سورة $surahNameArabic',
                    style: m.TextStyle(
                      fontFamily: 'arsura',
                      fontSize: 16.sp,
                      fontWeight: m.FontWeight.bold,
                      color: const m.Color(0xFF2D3142),
                    ),
                  ),
                  m.SizedBox(height: 6.h),
                  m.Text(
                    'آية $verseNumber - $verseText',
                    style: m.TextStyle(
                      fontSize: 14.sp,
                      fontWeight: m.FontWeight.w500,
                      color: const m.Color(0xFF4B5563),
                      height: 1.5,
                    ),
                    textAlign: m.TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RevelationBadge extends m.StatelessWidget {
  final bool isMeccan;

  const _RevelationBadge({required this.isMeccan});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      padding: m.EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: m.BoxDecoration(
        color: isMeccan ? const m.Color(0xFFE8F5E9) : const m.Color(0xFFFFF3E0),
        borderRadius: m.BorderRadius.circular(20.r),
      ),
      child: m.Text(
        isMeccan ? 'مكية' : 'مدنية',
        style: m.TextStyle(
          fontFamily: 'arsura',
          fontSize: 13.sp,
          fontWeight: m.FontWeight.w700,
          color: isMeccan
              ? const m.Color(0xFF2E7D32)
              : const m.Color(0xFFE65100),
        ),
      ),
    );
  }
}
