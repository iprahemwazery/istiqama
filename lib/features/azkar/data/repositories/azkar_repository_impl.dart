import '../../domain/entities/hisn_category.dart';
import '../../domain/repositories/azkar_repository.dart';
import '../datasources/hisn_azkar_local_data_source.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  final HisnAzkarLocalDataSource _dataSource;

  const AzkarRepositoryImpl(this._dataSource);

  @override
  Future<List<HisnCategory>> getCategories() async {
    final models = await _dataSource.loadCategories();
    return models;
  }
}
