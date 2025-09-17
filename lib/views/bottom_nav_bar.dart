import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/notification_model.dart';
import 'package:ecommerce_app_my/views/cart_view.dart';
import 'package:ecommerce_app_my/views/dashboard_view.dart';
import 'package:ecommerce_app_my/views/notifications_view.dart';
import 'package:ecommerce_app_my/views/wishlist_view.dart';
import 'package:ecommerce_app_my/views/profile_view.dart';
import 'package:flutter/material.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTap(int index) async {
    if (_currentIndex == index) {
      // agar same tab dobara select kare to popUntil
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });

      // 👉 Notifications tab open hone par read kar do
      if (index == 3) {
        await _markNotificationsAsRead();
      }
    }
  }

  Future<void> _markNotificationsAsRead() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("notificationReadStatus", isEqualTo: "unread")
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({"notificationReadStatus": "read"});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await _navigatorKeys[_currentIndex].currentState!.maybePop();
      },
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("notificationReadStatus", isEqualTo: "unread")
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData || snapshots.data == null) {
            return const SizedBox();
          } else {
            List<NotificationModel> list = snapshots.data!.docs
                .map(
                  (notification) =>
                      NotificationModel.fromJson(notification.data()),
                )
                .toList();

            return Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: [
                  _buildNavigator(0, const DashboardView()),
                  _buildNavigator(1, const CartView()),
                  _buildNavigator(2, const WishListView()),
                  _buildNavigator(3, const NotificationsView()),
                  _buildNavigator(4, const ProfileView()),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                selectedItemColor: const Color(0xffFCE0D5),
                unselectedItemColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: _onTap,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'WishList',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications),
                        if (list.isNotEmpty)
                          Positioned(
                            right: -6,
                            top: -2,
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  list.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'Notifications',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }
}
