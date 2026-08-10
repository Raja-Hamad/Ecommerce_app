import 'dart:io';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory({required String name, required String description, required File image});
  Future<Category> updateCategory(String id, {String? name, String? description, File? image});
    Future<void> deleteCategory(String id);

}
