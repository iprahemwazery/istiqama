import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:istiqama/features/tasbih/data/repositories/tasbih_repository_impl.dart';
import 'package:istiqama/features/tasbih/domain/entities/phrase_entity.dart';
import 'package:istiqama/features/tasbih/domain/usecases/get_phrases_usecase.dart';
import 'package:istiqama/features/tasbih/domain/usecases/increment_count_usecase.dart';
import 'package:istiqama/features/tasbih/domain/usecases/reset_counter_usecase.dart';

part 'tasbih_state.dart';

class TasbihCubit extends Cubit<TasbihState> {
  final GetPhrasesUseCase _getPhrasesUseCase;
  final IncrementCountUseCase _incrementCountUseCase;
  final ResetCounterUseCase _resetCounterUseCase;

  TasbihCubit()
    : _getPhrasesUseCase = GetPhrasesUseCase(
        repository: TasbihRepositoryImpl(),
      ),
      _incrementCountUseCase = const IncrementCountUseCase(),
      _resetCounterUseCase = const ResetCounterUseCase(),
      super(const TasbihState());

  void loadPhrases() {
    final phrases = _getPhrasesUseCase.call();
    emit(
      state.copyWith(
        phrases: phrases,
        activePhraseId: phrases.isNotEmpty ? phrases.first.id : '',
      ),
    );
  }

  void incrementCount() {
    final result = _incrementCountUseCase.call(
      phrases: state.phrases,
      activePhraseId: state.activePhraseId,
      totalToday: state.totalToday,
      rounds: state.rounds,
    );
    emit(
      state.copyWith(
        phrases: result.phrases,
        totalToday: result.totalToday,
        rounds: result.rounds,
      ),
    );
  }

  void selectPhrase(String phraseId) {
    if (phraseId == state.activePhraseId) return;
    emit(state.copyWith(activePhraseId: phraseId));
  }

  void resetCounter() {
    final result = _resetCounterUseCase.call(phrases: state.phrases);
    emit(
      state.copyWith(
        phrases: result.phrases,
        totalToday: result.totalToday,
        rounds: result.rounds,
      ),
    );
  }
}
