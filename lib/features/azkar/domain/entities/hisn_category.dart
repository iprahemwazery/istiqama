import 'zikr_item.dart';

class HisnCategory {
  final int id;
  final String title;
  final String? audio;
  final String? filename;
  final List<ZikrItem> items;

  const HisnCategory({
    required this.id,
    required this.title,
    this.audio,
    this.filename,
    required this.items,
  });
}
