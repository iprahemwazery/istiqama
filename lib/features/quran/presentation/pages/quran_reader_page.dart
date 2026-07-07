import 'package:istiqama/core/constants/app_constants.dart';
import 'package:istiqama/core/utils/save_manager.dart';
import 'package:istiqama/core/widgets/basmallah_widget.dart';
import 'package:istiqama/core/widgets/header_widget.dart';
import 'package:istiqama/features/settings/presentation/pages/settings_page.dart';

import 'package:flutter/material.dart' as m;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quran/quran.dart';

final Map<int, List<dynamic>> _pageDataCache = {};

List<dynamic> _getCachedPageData(int index) {
  if (_pageDataCache.containsKey(index)) {
    return _pageDataCache[index]!;
  }
  final data = getPageData(index);
  _pageDataCache[index] = data;
  return data;
}

final Map<String, String> _verseCache = {};

String _getCachedVerse(int surah, int verse) {
  final key = '$surah-$verse';
  if (_verseCache.containsKey(key)) {
    return _verseCache[key]!;
  }
  final text = getVerseQCF(surah, verse);
  _verseCache[key] = text;
  return text;
}

String _getCachedSurahName(dynamic jsonData, int surahIndex) {
  return jsonData[surahIndex]["name"];
}

class QuranViewPage extends StatefulWidget {
  final int pageNumber;
  final dynamic jsonData;
  final dynamic shouldHighlightText;
  final dynamic highlightVerse;

  const QuranViewPage({
    super.key,
    required this.pageNumber,
    required this.jsonData,
    required this.shouldHighlightText,
    required this.highlightVerse,
  });

  @override
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
  int index = 0;

  int? savedBookmarkPage;

  late PageController _pageController;

  loadBookmark() async {
    try {
      final page = await SaveManager.getLastPage();
      if (mounted) {
        setState(() {
          savedBookmarkPage = page;
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    index = widget.pageNumber;
    _pageController = PageController(initialPage: index);
    loadBookmark();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PageView.builder(
        reverse: true,
        scrollDirection: Axis.horizontal,
        onPageChanged: (a) {
          index = a;
          if (a > 0 && widget.jsonData != null) {
            String suraName = _getCachedSurahName(
              widget.jsonData,
              getPageData(a)[0]["surah"] - 1,
            );
            SaveManager.saveLastPage(a, suraName).catchError((_) {});
          }
        },
        controller: _pageController,
        itemCount: totalPagesCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/888-02.png",
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }
          return RepaintBoundary(
            child: QuranPageContent(
              index: index,
              jsonData: widget.jsonData,
              savedBookmarkPage: savedBookmarkPage,
              key: ValueKey(index),
            ),
          );
        },
      ),
    );
  }
}

class QuranPageContent extends StatefulWidget {
  final int index;
  final dynamic jsonData;
  final int? savedBookmarkPage;

  const QuranPageContent({
    super.key,
    required this.index,
    required this.jsonData,
    this.savedBookmarkPage,
  });

  @override
  State<QuranPageContent> createState() => _QuranPageContentState();
}

class _QuranPageContentState extends State<QuranPageContent>
    with AutomaticKeepAliveClientMixin {
  List<InlineSpan>? _cachedSpans;
  int _cachedIndex = -1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final index = widget.index;
    final jsonData = widget.jsonData;
    final screenSize = MediaQuery.of(context).size;
    final pageData = _getCachedPageData(index);
    final surahName = _getCachedSurahName(jsonData, pageData[0]["surah"] - 1);

    return Container(
      decoration: const BoxDecoration(color: quranPagesColor),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 52,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1B6B5A),
                    Color(0xFF2E9C7C),
                    Color(0xFF3DB88E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E9C7C).withValues(alpha: 0.38),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    "صفحة  $index",
                    style: const TextStyle(
                      fontFamily: 'arsura',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  if (widget.savedBookmarkPage == index) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.bookmark,
                      size: 16,
                      color: Color(0xFFFFD700),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: screenSize.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        surahName,
                        style: const TextStyle(
                          fontFamily: "Taha",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Positioned(
                        left: 0,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios, size: 24),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                String suraName2 = _getCachedSurahName(
                                  jsonData,
                                  pageData[0]["surah"] - 1,
                                );
                                await SaveManager.saveLastPage(
                                  index,
                                  suraName2,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "تم حفظ علامة التوقف بنجاح",
                                        textAlign: TextAlign.right,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.bookmark_add,
                                size: 24,
                                color: Colors.teal,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsPage(jsonData: jsonData),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.settings, size: 24),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if ((index == 1 || index == 2))
                  SizedBox(height: (screenSize.height * .15)),
                const SizedBox(height: 30),
                Directionality(
                  textDirection: m.TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textDirection: m.TextDirection.rtl,
                        textAlign: (index == 1 || index == 2 || index > 570)
                            ? TextAlign.center
                            : TextAlign.center,
                        softWrap: true,
                        locale: const Locale("ar"),
                        text: TextSpan(
                          style: TextStyle(
                            color: m.Colors.black,
                            fontSize: 23.sp.toDouble(),
                          ),
                          children: _getCachedVerseSpans(
                            index,
                            pageData,
                            jsonData,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<InlineSpan> _getCachedVerseSpans(
    int index,
    List<dynamic> pageData,
    dynamic jsonData,
  ) {
    if (_cachedIndex == index && _cachedSpans != null) {
      return _cachedSpans!;
    }
    _cachedSpans = _buildVerseSpans(index, pageData, jsonData);
    _cachedIndex = index;
    return _cachedSpans!;
  }

  List<InlineSpan> _buildVerseSpans(
    int index,
    List<dynamic> pageData,
    dynamic jsonData,
  ) {
    List<InlineSpan> spans = [];
    for (var e in pageData) {
      for (var i = e["start"]; i <= e["end"]; i++) {
        if (i == 1) {
          spans.add(
            WidgetSpan(
              child: HeaderWidget(e: e, jsonData: jsonData),
            ),
          );
          if (index != 187 && index != 1) {
            spans.add(const WidgetSpan(child: Basmallah()));
          }
          if (index == 187) {
            spans.add(WidgetSpan(child: Container(height: 10.h)));
          }
        }
        final verseText = _getCachedVerse(e["surah"], i);
        final displayText = i == e["start"]
            ? "${verseText.replaceAll(" ", "").substring(0, 1)}\u200A${verseText.replaceAll(" ", "").substring(1)}"
            : verseText.replaceAll(' ', '');

        spans.add(
          TextSpan(
            text: displayText,
            style: TextStyle(
              color: Colors.black,
              height: (index == 1 || index == 2) ? 2.h : 1.95.h,
              letterSpacing: 0.w,
              wordSpacing: 0,
              fontFamily: "QCF_P${index.toString().padLeft(3, "0")}",
              fontSize: index == 1 || index == 2
                  ? 28.sp
                  : index == 145 || index == 201
                  ? 22.4.sp
                  : index == 532 || index == 533
                  ? 22.5.sp
                  : 23.1.sp,
              backgroundColor: Colors.transparent,
            ),
            children: const <TextSpan>[],
          ),
        );
      }
    }
    return spans;
  }
}
