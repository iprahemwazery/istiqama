import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('adhkar.json structure matches model', () async {
    final file = File('assets/adhkar.json');
    final jsonString = await file.readAsString();
    final data = json.decode(jsonString) as List<dynamic>;

    expect(data, isNotEmpty);

    for (final cat in data) {
      final c = cat as Map<String, dynamic>;
      expect(c['id'], isA<int>(), reason: 'id should be int for ${c['category']}');
      expect(c['category'], isA<String>(), reason: 'category should be String for id ${c['id']}');
      
      final array = c['array'] as List<dynamic>;
      expect(array, isNotEmpty, reason: 'array should not be empty for ${c['category']}');
      
      for (final item in array) {
        final i = item as Map<String, dynamic>;
        expect(i['id'], isA<int>(), reason: 'item id should be int');
        expect(i['text'], isA<String>(), reason: 'item text should be String');
        expect(i['count'], isA<int>(), reason: 'item count should be int for id ${i['id']}');
      }
    }
  });
}
