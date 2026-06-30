class ZikrItem {
  final int id;
  final String text;
  final int count;
  final String? audio;
  final String? filename;

  const ZikrItem({
    required this.id,
    required this.text,
    required this.count,
    this.audio,
    this.filename,
  });
}
