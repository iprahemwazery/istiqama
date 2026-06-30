class PhraseEntity {
  final String id;
  final String text;
  final int target;
  final int currentCount;

  const PhraseEntity({
    required this.id,
    required this.text,
    this.target = 33,
    this.currentCount = 0,
  });

  PhraseEntity copyWith({
    String? id,
    String? text,
    int? target,
    int? currentCount,
  }) {
    return PhraseEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      target: target ?? this.target,
      currentCount: currentCount ?? this.currentCount,
    );
  }
}
