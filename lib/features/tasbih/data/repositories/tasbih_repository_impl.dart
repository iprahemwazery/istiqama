import '../../domain/entities/phrase_entity.dart';
import '../../domain/repositories/tasbih_repository.dart';
import '../models/tasbih_model.dart';

class TasbihRepositoryImpl implements TasbihRepository {
  @override
  List<PhraseEntity> getPhrases() {
    return TasbihModel.defaultPhrases();
  }
}
