import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/mock_data_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  final _ds = MockDataSource.instance;

  @override
  Future<List<Address>> getAddresses() async {
    await Future.delayed(_ds.latency);
    return _ds.addresses;
  }

  @override
  Future<void> addAddress(Address address) async {
    await Future.delayed(_ds.latency);
    if (address.isDefault) {
      for (var i = 0; i < _ds.addresses.length; i++) {
        _ds.addresses[i] = _ds.addresses[i].copyWith(isDefault: false);
      }
    }
    _ds.addresses.add(address);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await Future.delayed(_ds.latency);
    _ds.addresses.removeWhere((a) => a.id == id);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    await Future.delayed(_ds.latency);
    for (var i = 0; i < _ds.addresses.length; i++) {
      _ds.addresses[i] = _ds.addresses[i].copyWith(isDefault: _ds.addresses[i].id == id);
    }
  }
}
