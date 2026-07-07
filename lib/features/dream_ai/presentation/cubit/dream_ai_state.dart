import 'package:equatable/equatable.dart';

enum DreamAiStatus { initial, loading, loaded, error }

class DreamAiState extends Equatable {
  final DreamAiStatus status;
  final String dreamDescription;
  final String interpretation;
  final String? errorMessage;

  const DreamAiState({
    this.status = DreamAiStatus.initial,
    this.dreamDescription = '',
    this.interpretation = '',
    this.errorMessage,
  });

  DreamAiState copyWith({
    DreamAiStatus? status,
    String? dreamDescription,
    String? interpretation,
    String? errorMessage,
  }) {
    return DreamAiState(
      status: status ?? this.status,
      dreamDescription: dreamDescription ?? this.dreamDescription,
      interpretation: interpretation ?? this.interpretation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    dreamDescription,
    interpretation,
    errorMessage,
  ];
}
