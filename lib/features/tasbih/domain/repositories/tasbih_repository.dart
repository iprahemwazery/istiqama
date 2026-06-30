import '../entities/phrase_entity.dart';

abstract class TasbihRepository {
  List<PhraseEntity> getPhrases();
}
