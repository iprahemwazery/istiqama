import 'package:equatable/equatable.dart';

class VerseModel extends Equatable {
  final String title;
  final String text;
  final String surahName;
  final String verseNumber;

  const VerseModel({
    required this.title,
    required this.text,
    required this.surahName,
    required this.verseNumber,
  });

  @override
  List<Object?> get props => [title, text, surahName, verseNumber];
}
