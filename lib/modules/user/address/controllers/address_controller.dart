import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../data/repositories/address_repository_impl.dart';
import '../../../../domain/entities/address.dart';

class AddressController extends GetxController {
  final _repo = AddressRepositoryImpl();

  final RxList<Address> addresses = <Address>[].obs;
  final RxBool isLoading = true.obs;
  final Rxn<Address> selected = Rxn<Address>();

  final bool selectMode;
  AddressController({this.selectMode = false});

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      addresses.value = await _repo.getAddresses();
      if (addresses.isNotEmpty) {
        selected.value = addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void select(Address address) => selected.value = address;

  Future<void> setDefault(Address address) async {
    await _repo.setDefaultAddress(address.id);
    await fetch();
  }

  Future<void> deleteAddress(Address address) async {
    await _repo.deleteAddress(address.id);
    await fetch();
    AppSnackbar.info('Address removed');
  }

  void confirmSelection() {
    if (selected.value == null) {
      AppSnackbar.error('Please select a delivery address');
      return;
    }
    Get.toNamed(AppRoutes.checkout, arguments: selected.value);
  }
}

class AddAddressController extends GetxController {
  final _repo = AddressRepositoryImpl();

  final formKey = GlobalKey<FormState>();
  final labelCtrl = TextEditingController(text: 'Home');
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final countryCtrl = TextEditingController(text: 'Pakistan');
  final RxBool isDefault = false.obs;
  final RxBool isSaving = false.obs;

  Address? _editingAddress;
  bool get isEditing => _editingAddress != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Address) {
      _editingAddress = args;
      labelCtrl.text = args.label.isNotEmpty ? args.label : 'Home';
      nameCtrl.text = args.fullName;
      phoneCtrl.text = args.phone;
      addressCtrl.text = args.addressLine;
      cityCtrl.text = args.city;
      stateCtrl.text = args.state;
      zipCtrl.text = args.zipCode;
      countryCtrl.text = args.country;
      isDefault.value = args.isDefault;
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final address = Address(
        id: _editingAddress?.id ?? 'a${DateTime.now().millisecondsSinceEpoch}',
        label: labelCtrl.text.trim(),
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        addressLine: addressCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        state: stateCtrl.text.trim(),
        zipCode: zipCtrl.text.trim(),
        country: countryCtrl.text.trim(),
        isDefault: isDefault.value,
      );
      if (isEditing) {
        await _repo.updateAddress(address);
        AppSnackbar.success('Address updated');
      } else {
        await _repo.addAddress(address);
        AppSnackbar.success('Address saved');
        _resetForm();
      }
      // Let the snackbar animation start before the route pops, otherwise
      // the immediate navigation can cut it off before it's visible.
      await Future.delayed(const Duration(milliseconds: 200));
      Get.back(result: true);
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Something went wrong. Please try again.');
    } finally {
      isSaving.value = false;
    }
  }

  void _resetForm() {
    labelCtrl.text = 'Home';
    nameCtrl.clear();
    phoneCtrl.clear();
    addressCtrl.clear();
    cityCtrl.clear();
    stateCtrl.clear();
    zipCtrl.clear();
    countryCtrl.text = 'Pakistan';
    isDefault.value = false;
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    labelCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    zipCtrl.dispose();
    countryCtrl.dispose();
    super.onClose();
  }
}
