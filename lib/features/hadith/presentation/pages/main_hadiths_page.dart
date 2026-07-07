import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/hadith_model.dart';
import '../../domain/entities/hadith_item.dart';
import '../cubit/hadith_cubit.dart';
import '../cubit/hadith_state.dart';

class MainHadithsPage extends StatefulWidget {
  final String title;
  final String collectionId;

  const MainHadithsPage({
    super.key,
    required this.title,
    required this.collectionId,
  });

  @override
  State<MainHadithsPage> createState() => _MainHadithsPageState();
}

class _MainHadithsPageState extends State<MainHadithsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _hasRestoredScroll = false;

  @override
  void initState() {
    super.initState();
    context.read<HadithCubit>().loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _saveScrollState();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<HadithCubit>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      cubit.loadMoreHadiths();
    }
    if (_scrollController.hasClients) {
      cubit.saveScrollState(_scrollController.offset);
    }
  }

  void _saveScrollState() {
    if (_scrollController.hasClients) {
      context
          .read<HadithCubit>()
          .saveScrollState(_scrollController.offset);
    }
  }

  Future<void> _restoreScrollPosition(double savedOffset) async {
    if (_hasRestoredScroll || !_scrollController.hasClients) return;
    _hasRestoredScroll = true;
    if (savedOffset > 0) {
      _scrollController.jumpTo(savedOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: const Color(0xFF075E54),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        endDrawer: BlocBuilder<HadithCubit, HadithState>(
          buildWhen: (prev, current) => prev.sections != current.sections,
          builder: (context, state) {
            return _FilterDrawer(
              sections: state.sections,
              selectedBookId: state.selectedBookId,
              cubit: context.read<HadithCubit>(),
            );
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  _FilterButton(
                    onPressed: () =>
                        _scaffoldKey.currentState?.openEndDrawer(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SearchBar(
                      controller: _searchController,
                      onChanged: (query) =>
                          context.read<HadithCubit>().search(query),
                      onClear: () {
                        _searchController.clear();
                        context.read<HadithCubit>().clearSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<HadithCubit, HadithState>(
                builder: (context, state) {
                  switch (state.status) {
                    case HadithStatus.initial:
                    case HadithStatus.loading:
                      return const _ShimmerLoading();
                    case HadithStatus.error:
                      return _ErrorView(
                        message: state.errorMessage ?? 'حدث خطأ',
                        onRetry: () =>
                            context.read<HadithCubit>().loadInitial(),
                      );
                    case HadithStatus.loaded:
                    case HadithStatus.loadingMore:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (state.status == HadithStatus.loaded &&
                            !_hasRestoredScroll) {
                          _restoreScrollPosition(0);
                        }
                      });
                      return _HadithListView(
                        state: state,
                        scrollController: _scrollController,
                        collectionId: widget.collectionId,
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FilterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: const Color(0xFF075E54),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: const Icon(
          Icons.filter_list_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.w),
    );
  }
}

class _FilterDrawer extends StatelessWidget {
  final List<BookSection> sections;
  final int selectedBookId;
  final HadithCubit cubit;

  const _FilterDrawer({
    required this.sections,
    required this.selectedBookId,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueBooks = <int>{};
    final filtered = <BookSection>[];
    for (final s in sections) {
      if (uniqueBooks.add(s.id)) {
        filtered.add(s);
      }
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF075E54), Color(0xFF0A7E6F)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 32.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'تصفح حسب الكتاب',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${filtered.length} كتاب',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد أقسام متاحة',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black45,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: filtered.length + 1,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 60.w,
                        color: Colors.grey.withValues(alpha: 0.15),
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _BookTile(
                            bookId: 0,
                            title: 'جميع الأحاديث',
                            isSelected: selectedBookId == 0,
                            onTap: () {
                              cubit.selectBook(0);
                              Navigator.pop(context);
                            },
                          );
                        }
                        final section = filtered[index - 1];
                        final translatedTitle = section.title.isNotEmpty
                            ? cubit.translateSectionTitle(section.title)
                            : 'كتاب ${section.id}';
                        return _BookTile(
                          bookId: section.id,
                          title: translatedTitle,
                          isSelected: selectedBookId == section.id,
                          onTap: () {
                            cubit.selectBook(section.id);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  final int bookId;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BookTile({
    required this.bookId,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
      leading: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF075E54)
              : const Color(0xFF075E54).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: bookId > 0
              ? Text(
                  '$bookId',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        isSelected ? Colors.white : const Color(0xFF075E54),
                  ),
                )
              : Icon(
                  Icons.collections_bookmark_rounded,
                  size: 16.sp,
                  color: isSelected ? Colors.white : const Color(0xFFC7A44D),
                ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? const Color(0xFF075E54) : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: const Color(0xFF075E54),
              size: 20.sp,
            )
          : null,
      selected: isSelected,
      selectedTileColor: const Color(0xFF075E54).withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      dense: true,
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: 10,
        itemBuilder: (_, __) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HadithListView extends StatelessWidget {
  final HadithState state;
  final ScrollController scrollController;
  final String collectionId;

  const _HadithListView({
    required this.state,
    required this.scrollController,
    required this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    final hadiths = state.displayedHadiths;

    if (hadiths.isEmpty) {
      return const Center(
        child: Text('لا توجد نتائج', style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      children: [
        if (state.isSearching)
          _InfoBar(
            text:
                'نتائج البحث عن "${state.searchQuery}": ${hadiths.length}',
          ),
        if (!state.isSearching && state.totalCount > 0)
          _InfoBar(text: 'عدد الأحاديث: ${state.totalCount}'),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: hadiths.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == hadiths.length) {
                return const _BottomLoader();
              }
              return _HadithCard(
                hadith: hadiths[index],
                collectionId: collectionId,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InfoBar extends StatelessWidget {
  final String text;

  const _InfoBar({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onListen);
  }

  void _onListen() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        textDirection: TextDirection.rtl,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'ابحث في جميع الأحاديث...',
          hintTextDirection: TextDirection.rtl,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          prefixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black54),
                  onPressed: widget.onClear,
                )
              : const Icon(
                  Icons.search,
                  color: Color(0xFF075E54),
                ),
        ),
      ),
    );
  }
}

({String label, Color color, Color bg}) _gradeInfo(
  String collectionId,
  List<GradeItem> grades,
) {
  if (collectionId == 'bukhari') {
    return (
      label: 'صحيح',
      color: const Color(0xFF2E7D32),
      bg: const Color(0xFF2E7D32).withValues(alpha: 0.12),
    );
  }
  if (grades.isEmpty) {
    return (
      label: '',
      color: Colors.transparent,
      bg: Colors.transparent,
    );
  }
  final lower = grades.first.grade.toLowerCase();
  if (lower.contains('sahih')) {
    return (
      label: 'صحيح',
      color: const Color(0xFF2E7D32),
      bg: const Color(0xFF2E7D32).withValues(alpha: 0.12),
    );
  }
  if (lower.contains('hasan')) {
    return (
      label: 'حسن',
      color: const Color(0xFF1565C0),
      bg: const Color(0xFF1565C0).withValues(alpha: 0.12),
    );
  }
  if (lower.contains("da'if") || lower.contains('daeef') || lower.contains('weak')) {
    return (
      label: 'ضعيف',
      color: const Color(0xFFC62828),
      bg: const Color(0xFFC62828).withValues(alpha: 0.12),
    );
  }
  return (
    label: grades.first.grade,
    color: Colors.grey,
    bg: Colors.grey.withValues(alpha: 0.12),
  );
}

class _HadithCard extends StatelessWidget {
  final HadithItem hadith;
  final String collectionId;

  const _HadithCard({required this.hadith, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    final colonIndex = hadith.text.indexOf(':');
    String sanad = '';
    String matn = hadith.text;

    if (colonIndex > 0 && colonIndex < hadith.text.length - 1) {
      sanad = hadith.text.substring(0, colonIndex + 1);
      matn = hadith.text.substring(colonIndex + 1).trim();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(
            color: const Color(0xFF075E54).withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _GradeBadge(info: _gradeInfo(collectionId, hadith.grades)),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF075E54).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'حديث رقم ${hadith.hadithnumber}',
                      style: TextStyle(
                        color: const Color(0xFF075E54),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7A44D).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      color: const Color(0xFFC7A44D),
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (sanad.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Text(
                    sanad,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              Text(
                matn,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.6,
                  color: const Color(0xFF1A2E3B),
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1,
                color: Colors.grey.withValues(alpha: 0.15),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 14.sp,
                    color: Colors.black38,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'الكتاب ${hadith.bookNumber} • الحديث ${hadith.hadithnumber}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final ({String label, Color color, Color bg}) info;

  const _GradeBadge({required this.info});

  @override
  Widget build(BuildContext context) {
    if (info.label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(6.r),
        border:
            Border.all(color: info.color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        info.label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: info.color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
