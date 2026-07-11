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
}
