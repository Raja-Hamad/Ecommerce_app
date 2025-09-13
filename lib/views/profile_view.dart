import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/admin_all_faqs_view.dart';
import 'package:ecommerce_app_my/views/all_faqs_view.dart';
import 'package:ecommerce_app_my/views/my_orders_view.dart';
import 'package:ecommerce_app_my/views/my_shipping_address_view.dart';
import 'package:ecommerce_app_my/views/personal_details_view.dart';
import 'package:ecommerce_app_my/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final LocalStorage _localStorage = LocalStorage();
  String? name;
  String? imageUrl;
  String? emailAddress;
  bool isLoading = true;

  void getValues() async {
    name = await _localStorage.getValue("userName");
    emailAddress = await _localStorage.getValue("email");
    imageUrl = await _localStorage.getValue("imageUrl");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3), // shadow ka position
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl ?? '',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name ?? "",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  emailAddress ?? "",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        reusableWidget(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonalDetailsView(),
                              ),
                            );
                          },
                          title: "Personal Details",
                          icon: FontAwesomeIcons.person,
                        ),

                        reusableWidget(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrdersView(),
                              ),
                            );
                          },
                          title: "My Order",
                          icon: FontAwesomeIcons.bagShopping,
                        ),
                        reusableWidget(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WishListView(),
                              ),
                            );
                          },
                          title: "My Favorite",
                          icon: Icons.favorite,
                        ),
                        reusableWidget(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyShippingAddressView(),
                              ),
                            );
                          },
                          title: "Shipping Address",
                          icon: Icons.local_shipping,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        reusableWidget(
                          onPress: () {
                            if (emailAddress! == "kayanihamad0316@gmail.com") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminAllFaqsView(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllFaqsView(),
                                ),
                              );
                            }
                          },
                          title: "FAQs",
                          icon: Icons.question_answer,
                        ),

                        reusableWidget(
                          title: "Privacy Policy",
                          icon: Icons.security,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reusableWidget({
    required String title,
    required IconData icon,
    VoidCallback? onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color(0xffEEEEEE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Icon(icon, size: 20)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
