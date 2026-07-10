import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/address_repository_impl.dart';
import '../../../domain/entities/address.dart';

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
  final RxBool isDefault = false.obs;
  final RxBool isSaving = false.obs;

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final address = Address(
        id: 'a${DateTime.now().millisecondsSinceEpoch}',
        label: labelCtrl.text.trim(),
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        addressLine: addressCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        state: stateCtrl.text.trim(),
        zipCode: zipCtrl.text.trim(),
        isDefault: isDefault.value,
      );
      await _repo.addAddress(address);
      AppSnackbar.success('Address saved');
      Get.back(result: true);
    } finally {
      isSaving.value = false;
    }
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
    super.onClose();
  }
}
