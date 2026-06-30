import '../../domain/entities/zikr_item.dart';

class ZikrItemModel extends ZikrItem {
  const ZikrItemModel({
    required super.id,
    required super.text,
    required super.count,
    super.audio,
    super.filename,
  });

  factory ZikrItemModel.fromJson(Map<String, dynamic> json) {
    return ZikrItemModel(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 1,
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'count': count,
        'audio': audio,
        'filename': filename,
      };
}
