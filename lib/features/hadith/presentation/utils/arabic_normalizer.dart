String normalizeArabic(String text) {
  final withoutTashkeel = text
      .replaceAll(RegExp(r'[\u064B-\u0652]'), '')
      .replaceAll('\u0640', '');
  final normalized = withoutTashkeel
      .replaceAll('\u0623', '\u0627')
      .replaceAll('\u0625', '\u0627')
      .replaceAll('\u0622', '\u0627')
      .replaceAll('\u0629', '\u0647')
      .replaceAll('\u0649', '\u064A');
  return normalized;
}
