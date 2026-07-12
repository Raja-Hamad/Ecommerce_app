import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/address.dart';

class AddressRemoteDataSource {
  final _client = ApiClient.instance;

  Future<List<Address>> getAddresses() async {
    final response = await _client.get(ApiEndpoints.addresses);
    final data = response['addresses'] as List<dynamic>? ?? [];
    return data.map((json) => Address.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Returns the server-assigned id for the newly created address.
  /// The response shape isn't confirmed yet, so we look for the common
  /// places an id could show up and fall back to a local id otherwise.
  Future<String> addAddress(Address address) async {
    final response = await _client.post(ApiEndpoints.addresses, body: _toBody(address));

    final nested = response['address'];
    if (nested is Map<String, dynamic> && nested['_id'] != null) {
      return nested['_id'].toString();
    }
    if (response['_id'] != null) return response['_id'].toString();
    if (response['id'] != null) return response['id'].toString();
    return 'local_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> updateAddress(Address address) async {
    await _client.put(ApiEndpoints.updateAddress(address.id), body: _toBody(address));
  }

  Future<void> deleteAddress(String addressId) async {
    await _client.delete(ApiEndpoints.deleteAddress(addressId));
  }

  Map<String, dynamic> _toBody(Address address) => {
        'fullName': address.fullName,
        'phoneNumber': address.phone,
        'addressLine1': address.addressLine,
        'city': address.city,
        'state': address.state,
        'postalCode': address.zipCode,
        'country': address.country,
        'isDefault': address.isDefault,
      };
}
