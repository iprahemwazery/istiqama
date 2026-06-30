import 'package:flutter/services.dart';
import '../models/adhkar_model.dart';

class AzkarLocalDataSource {
  Future<List<AdhkarCategoryModel>> loadAdhkar() async {
    final jsonString = await rootBundle.loadString('assets/adhkar.json');
    return adhkarFromJson(jsonString);
  }
}
