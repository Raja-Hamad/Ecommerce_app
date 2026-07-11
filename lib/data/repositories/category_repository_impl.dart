import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final _remote = CategoryRemoteDataSource();

  @override
  Future<List<Category>> getCategories() => _remote.getCategories();
}
