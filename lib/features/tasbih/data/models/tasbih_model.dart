import '../../domain/entities/phrase_entity.dart';

class TasbihModel {
  static List<PhraseEntity> defaultPhrases() {
    return const [
      PhraseEntity(id: 'subhanAllah', text: 'سبحان الله', target: 33, currentCount: 20),
      PhraseEntity(id: 'alhamdulillah', text: 'الحمد لله', target: 33, currentCount: 0),
      PhraseEntity(id: 'allahuAkbar', text: 'الله أكبر', target: 33, currentCount: 0),
      PhraseEntity(id: 'laIlahaIllallah', text: 'لا إله إلا الله', target: 33, currentCount: 0),
    ];
  }
}
