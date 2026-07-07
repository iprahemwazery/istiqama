import 'dart:convert';

class GradeItem {
  final String grade;

  const GradeItem({required this.grade});

  factory GradeItem.fromJson(dynamic json) {
    return GradeItem(grade: json.toString());
  }
}

class HadithItem {
  final int hadithnumber;
  final int arabicnumber;
  final String text;
  final int bookNumber;
  final List<GradeItem> grades;

  const HadithItem({
    required this.hadithnumber,
    required this.arabicnumber,
    required this.text,
    required this.bookNumber,
    required this.grades,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    final ref = json['reference'] as Map<String, dynamic>?;
    final gradesList = (json['grades'] as List<dynamic>?)
            ?.map((e) => GradeItem.fromJson(e))
            .toList(growable: false) ??
        const [];
    final text = json['text'];
    return HadithItem(
      hadithnumber: (json['hadithnumber'] as num?)?.toInt() ?? 0,
      arabicnumber: (json['arabicnumber'] as num?)?.toInt() ?? 0,
      text: text is String ? text : text.toString(),
      bookNumber: (ref?['book'] as num?)?.toInt() ?? 1,
      grades: gradesList,
    );
  }
}

class Metadata {
  final String name;
  final Map<String, String> sections;
  final Map<String, SectionDetail> sectionDetails;

  const Metadata({
    required this.name,
    required this.sections,
    required this.sectionDetails,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    final sectionsRaw = json['sections'] as Map<String, dynamic>? ?? {};
    final detailsRaw =
        json['section_details'] as Map<String, dynamic>? ?? {};
    return Metadata(
      name: (json['name'] as String?) ?? '',
      sections: sectionsRaw.map((k, v) => MapEntry(k, v.toString())),
      sectionDetails: detailsRaw.map(
        (k, v) => MapEntry(
          k,
          SectionDetail.fromJson(v as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class SectionDetail {
  final int hadithnumberFirst;
  final int hadithnumberLast;

  const SectionDetail({
    required this.hadithnumberFirst,
    required this.hadithnumberLast,
  });

  factory SectionDetail.fromJson(Map<String, dynamic> json) {
    return SectionDetail(
      hadithnumberFirst: (json['hadithnumber_first'] as num?)?.toInt() ?? 0,
      hadithnumberLast: (json['hadithnumber_last'] as num?)?.toInt() ?? 0,
    );
  }
}

class HadithResponse {
  final Metadata metadata;
  final List<HadithItem> hadiths;

  const HadithResponse({
    required this.metadata,
    required this.hadiths,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    return HadithResponse(
      metadata: Metadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      hadiths: (json['hadiths'] as List<dynamic>?)
              ?.map(
                  (e) => HadithItem.fromJson(e as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
    );
  }
}

HadithResponse parseHadithJson(String jsonString) {
  final decoded = json.decode(jsonString) as Map<String, dynamic>;
  return HadithResponse.fromJson(decoded);
}
