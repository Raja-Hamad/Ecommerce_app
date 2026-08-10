import 'dart:io';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/category.dart';

class CategoryRemoteDataSource {
  final _client = ApiClient.instance;

  Future<List<Category>> getCategories() async {
    final response = await _client.get(ApiEndpoints.categories);
    final data = response['categories'] as List<dynamic>? ?? [];
    return data.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Category> createCategory({required String name, required String description, required File image}) async {
    final response = await _client.multipart(
      ApiEndpoints.createCategory,
      fields: {'name': name, 'description': description},
      files: {'image': image},
    );
    return Category.fromJson(response['category'] as Map<String, dynamic>? ?? response);
  }

  Future<Category> updateCategory(String id, {String? name, String? description, File? image}) async {
    final response = await _client.multipart(
      ApiEndpoints.categoryById(id),
      method: 'PUT',
      fields: {
        'name': ?name,
        'description': ?description,
      },
      files: image != null ? {'image': image} : const {},
    );
    return Category.fromJson(response['category'] as Map<String, dynamic>? ?? response);
  }
    Future<void> deleteCategory(String id) async {
    await _client.delete(ApiEndpoints.categoryById(id));
  }
}
