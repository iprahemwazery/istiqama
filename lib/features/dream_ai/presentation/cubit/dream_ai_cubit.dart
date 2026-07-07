import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'dream_ai_state.dart';

class DreamAiCubit extends Cubit<DreamAiState> {
  late final GenerativeModel _model;

  DreamAiCubit() : super(const DreamAiState()) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: 'AQ.Ab8RN6KVm3kUMr8QP1Mwb0UXLtY0V0w9cWBxCYvfqlT1ZL3N5g',
      systemInstruction: Content.system(
        'أنت مفسر أحلام إسلامي خبير، فسر الحلم بناءً على كتاب ابن سيرين والنابلسي بأسلوب شرعي مطمئن وبلغة عربية فصحى وبدون ذكر أنك ذكاء اصطناعي.',
      ),
    );
  }

  void _emitIfOpen(DreamAiState newState) {
    if (!isClosed) emit(newState);
  }

  void updateDreamDescription(String value) {
    _emitIfOpen(state.copyWith(dreamDescription: value));
  }

  Future<void> interpretDream() async {
    final dream = state.dreamDescription.trim();
    if (dream.isEmpty) return;

    _emitIfOpen(state.copyWith(
      status: DreamAiStatus.loading,
      interpretation: '',
      errorMessage: null,
    ));

    try {
      final prompt = 'فسر لي هذا الحلم: $dream';
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? 'عذراً، لم أتمكن من تفسير الحلم. حاول مرة أخرى.';

      _emitIfOpen(state.copyWith(
        status: DreamAiStatus.loaded,
        interpretation: text,
      ));
    } catch (e) {
      _emitIfOpen(state.copyWith(
        status: DreamAiStatus.error,
        errorMessage: 'حدث خطأ أثناء التفسير: ${e.toString()}',
      ));
    }
  }

  void reset() {
    _emitIfOpen(const DreamAiState());
  }
}
