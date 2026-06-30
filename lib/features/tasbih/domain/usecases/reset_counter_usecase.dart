import '../entities/phrase_entity.dart';

class ResetResult {
  final List<PhraseEntity> phrases;
  final int totalToday;
  final int rounds;

  const ResetResult({
    required this.phrases,
    required this.totalToday,
    required this.rounds,
  });
}

class ResetCounterUseCase {
  const ResetCounterUseCase();

  ResetResult call({
    required List<PhraseEntity> phrases,
  }) {
    final reset = phrases.map((p) => p.copyWith(currentCount: 0)).toList();
    return ResetResult(phrases: reset, totalToday: 0, rounds: 0);
  }
}
