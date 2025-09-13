import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/product_model.dart';
import 'package:ecommerce_app_my/views/add_product.dart';
import 'package:ecommerce_app_my/views/product_list_view.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddProduct()));
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("products")
                .where(
                  "adminId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                // Show shimmer
                return ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return const ReusableShimmerWidget();
                  },
                );
              }

              if (!snapshots.hasData || snapshots.data == null) {
                return Center(child: Text("No products found"));
              } else {
                List<ProductModel> shoesList = snapshots.data!.docs
                    .where((doc) => doc['category'] == "Shoes")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                List<ProductModel> newArrivalsList = snapshots.data!.docs
                    .where((doc) => doc['category'] == "New Arrivals")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                List<ProductModel> clothes = snapshots.data!.docs
                    .where((doc) => doc['category'] == "Clothes")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                List<ProductModel> jewelry = snapshots.data!.docs
                    .where((doc) => doc['category'] == "Jewelry")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                List<ProductModel> electronicsList = snapshots.data!.docs
                    .where((doc) => doc['category'] == "Electronics")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                List<ProductModel> bagsList = snapshots.data!.docs
                    .where((doc) => doc['category'] == "Bags")
                    .map((json) => ProductModel.fromJson(json.data()))
                    .toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      "Categories",
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'New Arrivals',
                              listOfProduct: newArrivalsList,
                            ),
                          ),
                        );
                      },
                      title: "New Arrivals",
                      icon: Icons.shopping_cart_checkout_outlined,
                      totalCount: newArrivalsList.length,
                    ),
                    const SizedBox(height: 15),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'Shoes',
                              listOfProduct: shoesList,
                            ),
                          ),
                        );
                      },
                      title: "Shoes",
                      icon: FontAwesomeIcons.shoePrints,
                      totalCount: shoesList.length,
                    ),
                    const SizedBox(height: 15),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'Bags',
                              listOfProduct: bagsList,
                            ),
                          ),
                        );
                      },
                      title: "Bags",
                      icon: FontAwesomeIcons.bagShopping,
                      totalCount: bagsList.length,
                    ),
                    const SizedBox(height: 15),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'Clothes',
                              listOfProduct: clothes,
                            ),
                          ),
                        );
                      },
                      title: "Clothes",
                      icon: FontAwesomeIcons.shirt,
                      totalCount: clothes.length,
                    ),
                    const SizedBox(height: 15),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'Electronics',
                              listOfProduct: electronicsList,
                            ),
                          ),
                        );
                      },
                      title: "Electronics",
                      icon: FontAwesomeIcons.laptop,
                      totalCount: electronicsList.length,
                    ),
                    const SizedBox(height: 15),
                    reusabelContainer(
                      onPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductListView(
                              title: 'Jewelry',
                              listOfProduct: jewelry,
                            ),
                          ),
                        );
                      },
                      title: "Jewelry",
                      icon: FontAwesomeIcons.gem,
                      totalCount: jewelry.length,
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget reusabelContainer({
    required String title,
    required VoidCallback onPress,
    required IconData icon,
    required int totalCount,
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 15),
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "${totalCount.toString()} Products",
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
