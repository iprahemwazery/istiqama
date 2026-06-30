class AzkarTextHelper {
  AzkarTextHelper._();

  static String getCleanedText(String rawText, {required bool isSabah}) {
    if (isSabah) {
      final eveningPattern = RegExp(r'\[[^\]]*?(أمسى|الليلة)[^\]]*\]');
      String result = rawText.replaceAll(eveningPattern, '');
      return result.replaceAll(RegExp(r'\s+'), ' ').trim();
    } else {
      String result = rawText
          .replaceAll('أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
              'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ')
          .replaceAll('أَصْبَحْنَا', 'أَمْسَيْنَا')
          .replaceAll('أَصْبَحْتُ', 'أَمْسَيْتُ')
          .replaceAll('أَصْبَحَ', 'أَمْسَى')
          .replaceAll('هَذَا الْيَوْمِ', 'هَذِهِ اللَّيْلَةِ')
          .replaceAll('هَذَا الْيَوْمَ', 'هَذِهِ اللَّيْلَةَ')
          .replaceAll('الْيَوْمِ', 'اللَّيْلَةِ')
          .replaceAll('الْيَوْمَ', 'اللَّيْلَةَ')
          .replaceAll('بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا',
              'بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا')
          .replaceAll('وَإِلَيْكَ النُّشُورُ', 'وَإِلَيْكَ الْمَصِيرُ')
          .replaceAll(RegExp(r'\[[^\]]*\]'), '');
      return result.replaceAll(RegExp(r'\s+'), ' ').trim();
    }
  }
}
