import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/order_model.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAllOrdersView extends StatefulWidget {
  const AdminAllOrdersView({super.key});

  @override
  State<AdminAllOrdersView> createState() => _AdminAllOrdersViewState();
}

class _AdminAllOrdersViewState extends State<AdminAllOrdersView> {
    bool isOnGoingSelected = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 30,),
          Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "My Orders",
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOnGoingSelected = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isOnGoingSelected
                                  ? Colors.black
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.black,
                                width: 0.2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              "Ongoing",
                              style: GoogleFonts.dmSans(
                                color: isOnGoingSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOnGoingSelected = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: !isOnGoingSelected
                                  ? Colors.black
                                  : Colors.transparent,
                              border: Border.all(
                                color: Colors.black,
                                width: 0.2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              "Completed",
                              style: GoogleFonts.dmSans(
                                color: !isOnGoingSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
         const SizedBox(height: 30),
                isOnGoingSelected
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("orders")
                            .where("status", isEqualTo: "Pending")
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (!snapshots.hasData || snapshots.data == null) {
                            return const SizedBox();
                          } else if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const ReusableShimmerWidget();
                              },
                            );
                          } else if (snapshots.data!.docs.isEmpty) {
                            // Agar koi address add nahi hai
                            return Center(
                              child: Text(
                                "You did not place any order yet.",
                                style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          } else {
                            List<OrderModel> allOrders = snapshots.data!.docs
                                .map(
                                  (order) => OrderModel.fromJson(order.data()),
                                )
                                .toList();
                            return ListView.builder(
                              itemCount: allOrders.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final order = allOrders[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Order Header
                                        Text(
                                          "Order ID: ${order.id}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // Saare cart items ek ek kar ke
                                        ListView.builder(
                                          itemCount: order.cartModel.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, cartIndex) {
                                            final cartItem =
                                                order.cartModel[cartIndex];

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  // Product image
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.network(
                                                        cartItem
                                                            .productModel
                                                            .imageUrls
                                                            .first,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Product info
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cartItem
                                                              .productModel
                                                              .title,
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        Text(
                                                          cartItem
                                                              .productModel
                                                              .subtitle,
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Size: ${cartItem.productSize ?? '-'}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          "Qty: ${cartItem.quantity}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          "Price: ${cartItem.productModel.price}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        const Divider(),
                                        // Order Footer (status, total, etc.)
                                        Text(
                                          "Total: ${order.totalAmount}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Status: ${order.status}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("orders")
                            .where("status", isNotEqualTo: "Pending")
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (!snapshots.hasData || snapshots.data == null) {
                            return const SizedBox();
                          } else if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const ReusableShimmerWidget();
                              },
                            );
                          } else if (snapshots.data!.docs.isEmpty) {
                            // Agar koi address add nahi hai
                            return Center(
                              child: Text(
                                "Not any order completed yet.",
                                style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          } else {
                            List<OrderModel> allOrders = snapshots.data!.docs
                                .map(
                                  (order) => OrderModel.fromJson(order.data()),
                                )
                                .toList();
                            return ListView.builder(
                              itemCount: allOrders.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final order = allOrders[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
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
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Order Header
                                        Text(
                                          "Order ID: ${order.id}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // Saare cart items ek ek kar ke
                                        ListView.builder(
                                          itemCount: order.cartModel.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, cartIndex) {
                                            final cartItem =
                                                order.cartModel[cartIndex];

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Row(
                                                children: [
                                                  // Product image
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.network(
                                                        cartItem
                                                            .productModel
                                                            .imageUrls
                                                            .first,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  // Product info
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cartItem
                                                              .productModel
                                                              .title,
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        Text(
                                                          cartItem
                                                              .productModel
                                                              .subtitle,
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "Size: ${cartItem.productSize ?? '-'}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          "Qty: ${cartItem.quantity}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          "Price: ${cartItem.productModel.price}",
                                                          style:
                                                              GoogleFonts.dmSans(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        const Divider(),
                                        // Order Footer (status, total, etc.)
                                        Text(
                                          "Total: ${order.totalAmount}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Status: ${order.status}",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
        ],
      ),)),
    );
  }
}