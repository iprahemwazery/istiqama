import '../../domain/entities/hisn_category.dart';
import 'zikr_item_model.dart';

class HisnCategoryModel extends HisnCategory {
  const HisnCategoryModel({
    required super.id,
    required super.title,
    super.audio,
    super.filename,
    required super.items,
  });

  factory HisnCategoryModel.fromJson(Map<String, dynamic> json) {
    final array = json['array'] as List<dynamic>? ?? [];
    return HisnCategoryModel(
      id: (json['id'] as num).toInt(),
      title: json['category'] as String? ?? '',
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
      items: array
          .map((e) =>
              ZikrItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': title,
        'audio': audio,
        'filename': filename,
        'array': (items as List<ZikrItemModel>).map((e) => e.toJson()).toList(),
      };
}
