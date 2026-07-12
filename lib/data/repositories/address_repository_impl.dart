import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/remote/address_remote_data_source.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl._internal();
  static final AddressRepositoryImpl _instance = AddressRepositoryImpl._internal();
  factory AddressRepositoryImpl() => _instance;

  final _remote = AddressRemoteDataSource();

  // Delete/set-default endpoints aren't available yet, so we hydrate the
  // cache from the server once and keep those two operations local —
  // refetching on every call would silently revert them back to the
  // server's last known state. This class is a singleton so every screen
  // (list, add, edit) shares the same cache instead of drifting apart.
  List<Address> _cache = [];
  bool _hydrated = false;

  @override
  Future<List<Address>> getAddresses() async {
    if (!_hydrated) {
      _cache = await _remote.getAddresses();
      _hydrated = true;
    }
    return _cache.toList();
  }

  @override
  Future<void> addAddress(Address address) async {
    await _remote.addAddress(address);
    // The server may normalize fields (e.g. trimming), so re-sync from it.
    _cache = await _remote.getAddresses();
    _hydrated = true;
  }

  @override
  Future<void> updateAddress(Address address) async {
    await _remote.updateAddress(address);
    // Re-sync the whole list from the server rather than patching locally.
    _cache = await _remote.getAddresses();
    _hydrated = true;
  }

  @override
  Future<void> deleteAddress(String id) async {
    await _remote.deleteAddress(id);
    _cache.removeWhere((a) => a.id == id);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    // TODO: sync with backend once a set-default endpoint is available.
    for (var i = 0; i < _cache.length; i++) {
      _cache[i] = _cache[i].copyWith(isDefault: _cache[i].id == id);
    }
  }
}
