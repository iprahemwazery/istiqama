part of 'tasbih_cubit.dart';

class TasbihState extends Equatable {
  final List<PhraseEntity> phrases;
  final String activePhraseId;
  final int totalToday;
  final int rounds;

  const TasbihState({
    this.phrases = const [],
    this.activePhraseId = '',
    this.totalToday = 0,
    this.rounds = 0,
  });

  PhraseEntity? get activePhrase {
    try {
      return phrases.firstWhere((p) => p.id == activePhraseId);
    } catch (_) {
      return null;
    }
  }

  TasbihState copyWith({
    List<PhraseEntity>? phrases,
    String? activePhraseId,
    int? totalToday,
    int? rounds,
  }) {
    return TasbihState(
      phrases: phrases ?? this.phrases,
      activePhraseId: activePhraseId ?? this.activePhraseId,
      totalToday: totalToday ?? this.totalToday,
      rounds: rounds ?? this.rounds,
    );
  }

  @override
  List<Object?> get props => [
        phrases,
        activePhraseId,
        totalToday,
        rounds,
      ];
}
