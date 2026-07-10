import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/mock_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(_ds.latency);
    return _ds.categories;
  }
}
