import 'dart:convert';

class ZekrItemModel {
  final int id;
  final String text;
  final int count;
  final String? audio;
  final String? filename;

  const ZekrItemModel({
    required this.id,
    required this.text,
    required this.count,
    this.audio,
    this.filename,
  });

  factory ZekrItemModel.fromJson(Map<String, dynamic> json) {
    return ZekrItemModel(
      id: json['id'] as int,
      text: json['text'] as String,
      count: json['count'] as int,
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

class AdhkarCategoryModel {
  final int id;
  final String category;
  final String? audio;
  final String? filename;
  final List<ZekrItemModel> array;

  const AdhkarCategoryModel({
    required this.id,
    required this.category,
    this.audio,
    this.filename,
    required this.array,
  });

  factory AdhkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdhkarCategoryModel(
      id: json['id'] as int,
      category: json['category'] as String,
      audio: json['audio'] as String?,
      filename: json['filename'] as String?,
      array: (json['array'] as List<dynamic>)
          .map((e) => ZekrItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

List<AdhkarCategoryModel> adhkarFromJson(String str) =>
    (json.decode(str) as List<dynamic>)
        .map((e) => AdhkarCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
