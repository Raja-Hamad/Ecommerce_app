import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order.dart';

class AdminOrdersController extends GetxController {
  final _repo = OrderRepositoryImpl();

  final searchCtrl = TextEditingController();
  Timer? _debounce;

  final RxnString selectedStatus = RxnString();
  final RxnString selectedPaymentStatus = RxnString();
  final RxnString selectedPaymentMethod = RxnString();
  final RxnString selectedSort = RxnString();

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  int _page = 1;
  int totalPages = 1;
  final RxInt totalOrders = 0.obs;

  static const statusOptions = [
    (null, 'All Status'),
    ('pending', 'Pending'),
    ('confirmed', 'Confirmed'),
    ('shipped', 'Shipped'),
    ('delivered', 'Delivered'),
    ('cancelled', 'Cancelled'),
  ];

  static const paymentStatusOptions = [
    (null, 'All Payments'),
    ('paid', 'Paid'),
    ('pending', 'Pending'),
    ('failed', 'Failed'),
  ];

  static const paymentMethodOptions = [
    (null, 'All Methods'),
    ('STRIPE', 'Stripe'),
    ('COD', 'Cash on Delivery'),
  ];

  static const sortOptions = [
    (null, 'Default'),
    ('latest', 'Latest First'),
    ('oldest', 'Oldest First'),
    ('amountHigh', 'Amount: High to Low'),
    ('amountLow', 'Amount: Low to High'),
  ];

  @override
  void onInit() {
    super.onInit();
    fetch(reset: true);
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => fetch(reset: true));
  }

  void setStatus(String? status) {
    selectedStatus.value = status;
    fetch(reset: true);
  }

  void setPaymentStatus(String? status) {
    selectedPaymentStatus.value = status;
    fetch(reset: true);
  }

  void setPaymentMethod(String? method) {
    selectedPaymentMethod.value = method;
    fetch(reset: true);
  }

  void setSort(String? sort) {
    selectedSort.value = sort;
    fetch(reset: true);
  }

  Future<void> fetch({bool reset = false}) async {
    if (reset) {
      _page = 1;
      isLoading.value = true;
    }
    try {
      final page = await _repo.getAllOrders(
        search: searchCtrl.text.trim(),
        status: selectedStatus.value,
        paymentStatus: selectedPaymentStatus.value,
        paymentMethod: selectedPaymentMethod.value,
        sort: selectedSort.value,
        page: _page,
      );
      totalPages = page.totalPages;
      totalOrders.value = page.totalOrders;
      orders.value = reset ? page.orders : [...orders, ...page.orders];
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load orders. Please try again.');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || _page >= totalPages) return;
    isLoadingMore.value = true;
    _page++;
    await fetch();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }
}
