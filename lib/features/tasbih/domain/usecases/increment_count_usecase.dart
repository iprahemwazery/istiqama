import '../entities/phrase_entity.dart';

class IncrementResult {
  final List<PhraseEntity> phrases;
  final int totalToday;
  final int rounds;

  const IncrementResult({
    required this.phrases,
    required this.totalToday,
    required this.rounds,
  });
}

class IncrementCountUseCase {
  const IncrementCountUseCase();

  IncrementResult call({
    required List<PhraseEntity> phrases,
    required String activePhraseId,
    required int totalToday,
    required int rounds,
  }) {
    final index = phrases.indexWhere((p) => p.id == activePhraseId);
    if (index == -1) {
      return IncrementResult(phrases: phrases, totalToday: totalToday, rounds: rounds);
    }

    final phrase = phrases[index];
    final newCount = phrase.currentCount + 1;
    int newTotalToday = totalToday + 1;
    int newRounds = rounds;

    final updated = phrase.copyWith(currentCount: newCount >= phrase.target ? 0 : newCount);
    if (newCount >= phrase.target) {
      newRounds += 1;
    }

    final updatedPhrases = List<PhraseEntity>.from(phrases);
    updatedPhrases[index] = updated;

    return IncrementResult(
      phrases: updatedPhrases,
      totalToday: newTotalToday,
      rounds: newRounds,
    );
  }
}
