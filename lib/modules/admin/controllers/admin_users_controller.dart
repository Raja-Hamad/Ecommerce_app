import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/admin_repository_impl.dart';
import '../../../domain/entities/recent_user.dart';

class AdminUsersController extends GetxController {
  final _repo = AdminRepositoryImpl();

  final searchCtrl = TextEditingController();
  Timer? _debounce;

  final RxnString selectedStatus = RxnString();
  final RxnString selectedSort = RxnString();

  final RxList<RecentUser> users = <RecentUser>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;

  int _page = 1;
  int totalPages = 1;
  final RxInt totalUsers = 0.obs;

  static const statusOptions = [
    (null, 'All Status'),
    ('active', 'Active'),
    ('blocked', 'Blocked'),
  ];

  static const sortOptions = [
    (null, 'Default'),
    ('latest', 'Latest First'),
    ('oldest', 'Oldest First'),
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
      final page = await _repo.getAllUsers(
        search: searchCtrl.text.trim(),
        status: selectedStatus.value,
        sort: selectedSort.value,
        page: _page,
      );
      totalPages = page.totalPages;
      totalUsers.value = page.totalUsers;
      users.value = reset ? page.users : [...users, ...page.users];
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to load users. Please try again.');
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

  Future<void> updateStatus(RecentUser user, String newStatus) async {
    try {
      await _repo.updateUserStatus(user.id, newStatus);
      final index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) users[index] = user.copyWith(status: newStatus);
      AppSnackbar.success('User status updated');
    } catch (e) {
      AppSnackbar.error(e is AppException ? e.message : 'Failed to update status. Please try again.');
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }
}
