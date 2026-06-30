import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/hisn_category_model.dart';

abstract class HisnAzkarLocalDataSource {
  Future<List<HisnCategoryModel>> loadCategories();
}

class HisnAzkarLocalDataSourceImpl implements HisnAzkarLocalDataSource {
  @override
  Future<List<HisnCategoryModel>> loadCategories() async {
    final jsonString = await rootBundle.loadString('assets/adhkar.json');
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    return decoded
        .map((e) => HisnCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
