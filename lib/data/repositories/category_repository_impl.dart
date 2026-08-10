import 'dart:io';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final _remote = CategoryRemoteDataSource();

  @override
  Future<List<Category>> getCategories() => _remote.getCategories();

  @override
  Future<Category> createCategory({
    required String name,
    required String description,
    required File image,
  }) => _remote.createCategory(
    name: name,
    description: description,
    image: image,
  );

  @override
  Future<Category> updateCategory(
    String id, {
    String? name,
    String? description,
    File? image,
  }) => _remote.updateCategory(
    id,
    name: name,
    description: description,
    image: image,
  );
  @override
  Future<void> deleteCategory(String id) => _remote.deleteCategory(id);
}
