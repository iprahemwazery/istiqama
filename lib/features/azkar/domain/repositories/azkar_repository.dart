import '../entities/hisn_category.dart';

abstract class AzkarRepository {
  Future<List<HisnCategory>> getCategories();
}
