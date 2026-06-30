import '../entities/phrase_entity.dart';
import '../repositories/tasbih_repository.dart';

class GetPhrasesUseCase {
  final TasbihRepository repository;

  GetPhrasesUseCase({required this.repository});

  List<PhraseEntity> call() {
    return repository.getPhrases();
  }
}
