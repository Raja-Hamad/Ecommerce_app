import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/controllers/add_to_cart_or_wishlist_controller.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/models/order_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class PlaceOrderView extends StatefulWidget {
  const PlaceOrderView({super.key});

  @override
  State<PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  AddressModel? selectedAddress;
  List<CartModel> cartList = [];

  final AddToCartOrWishlistController _addToCartOrWishlistController = Get.put(
    AddToCartOrWishlistController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
          onTap: () async {
            OrderModel orderModel = OrderModel(
              addressModel: selectedAddress!,
              cartModel: cartList,
              id: Uuid().v4(),
              paymentMethod: "Cash On Delievery(COD)",
              paymentStatus: "Unpaid",
              status: 'Pending',
              totalAmount: 456666,
              userId: FirebaseAuth.instance.currentUser!.uid,
            );
            _addToCartOrWishlistController
                .addToCartOrWishList(context, orderModel, "orders")
                .then((value) {
                  FlushBarMessages.successMessageFlushBar(
                    "Your oder is processed successfully",
                    // ignore: use_build_context_synchronously
                    context,
                  );
                });
          },
          child: Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _addToCartOrWishlistController.isLoading.value
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Place Order",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("delievery_address")
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData || snapshots.data == null) {
              return const SizedBox();
            } else if (snapshots.connectionState == ConnectionState.waiting) {
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
                  "No delivery address found. Please add one.",
                  style: GoogleFonts.dmSans(color: Colors.black, fontSize: 16),
                ),
              );
            } else {
              // ✅ AddressModel assign karna
              var doc = snapshots.data!.docs.first.data();
              selectedAddress = AddressModel.fromJson(doc);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Delievery Address",
                        style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ✅ Show Address Details
                      if (selectedAddress != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // 👈 crossAxis bhi start
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
                                      offset: const Offset(
                                        0,
                                        3,
                                      ), // shadow ka position
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // 👈 column start
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 👈 column start
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start, // 👈 row start
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(selectedAddress!.name),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Calling Code: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(selectedAddress!.callingCode),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(selectedAddress!.phone),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            selectedAddress!.fullAddress,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "State: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(selectedAddress!.state),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Country: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${selectedAddress!.country} (${selectedAddress!.countryCode})",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Zip Code: ",
                                          style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(selectedAddress!.zipCode),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("cart")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return SizedBox();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ReusableShimmerWidget();
                              },
                            );
                          } else {
                            cartList = snapshot.data!.docs
                                .map((json) => CartModel.fromJson(json.data()))
                                .toList();

                            if (cartList.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Your cart is empty",
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: cartList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final cartProduct = cartList[index];
                                final docId = snapshot
                                    .data!
                                    .docs[index]
                                    .id; // Firestore doc ID

                                return Dismissible(
                                  key: Key(docId),
                                  direction: DismissDirection
                                      .endToStart, // right-to-left swipe
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(Icons.delete, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onDismissed: (direction) async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        .collection("cart")
                                        .doc(docId)
                                        .delete();

                                    FlushBarMessages.successMessageFlushBar(
                                      "${cartProduct.productModel.title} removed from cart",
                                      // ignore: use_build_context_synchronously
                                      context,
                                    );
                                  },
                                  child: Padding(
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
                                            offset: const Offset(
                                              0,
                                              3,
                                            ), // shadow position
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    cartProduct
                                                        .productModel
                                                        .imageUrls
                                                        .first,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cartProduct
                                                        .productModel
                                                        .title,
                                                    style: GoogleFonts.dmSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    cartProduct
                                                        .productModel
                                                        .subtitle,
                                                    style: GoogleFonts.dmSans(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                  "\$${  cartProduct
                                                        .productModel
                                                        .price.toString()}",
                                                    style: GoogleFonts.dmSans(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffEEEEEE),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // minus action
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  cartProduct.quantity
                                                      .toString(),
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                GestureDetector(
                                                  onTap: () {
                                                    // plus action
                                                  },
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
