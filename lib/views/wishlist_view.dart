import 'package:ecommerce_app_my/controllers/add_to_cart_or_wishlist_controller.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/models/wishlist_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class WishListView extends StatefulWidget {
  const WishListView({super.key});

  @override
  State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  final AddToCartOrWishlistController _cartOrWishlistController = Get.put(
    AddToCartOrWishlistController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  "Wishlist",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("wishList")
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
                      final wishList = snapshot.data!.docs
                          .map((json) => WishlistModel.fromJson(json.data()))
                          .toList();

                      if (wishList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Your wishlist is empty",
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
                        itemCount: wishList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final whishListProduct = wishList[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            child: Image.network(
                                              whishListProduct
                                                  .productModel
                                                  .imageUrls
                                                  .first,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              whishListProduct
                                                  .productModel
                                                  .title,
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              whishListProduct
                                                  .productModel
                                                  .subtitle,
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              whishListProduct
                                                  .productModel
                                                  .price,
                                              style: GoogleFonts.dmSans(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .collection("cart")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return SizedBox();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox();
                                        } else {
                                          final cartList = snapshot.data!.docs
                                              .map(
                                                (json) => CartModel.fromJson(
                                                  json.data(),
                                                ),
                                              )
                                              .toList();

                                          bool isPresent = cartList.any(
                                            (product) =>
                                                product.productModel.id ==
                                                whishListProduct
                                                    .productModel
                                                    .id,
                                          );
                                          return GestureDetector(
                                            onTap: () {
                                              if (isPresent) {
                                                FlushBarMessages.successMessageFlushBar(
                                                  "This product is already in Cart",
                                                  context,
                                                );
                                              } else {
                                                CartModel cartModel = CartModel(
                                                  id: Uuid().v4(),
                                                  productModel: whishListProduct
                                                      .productModel,
                                                );

                                                _cartOrWishlistController
                                                    .addToCartOrWishList(
                                                      context,
                                                      cartModel,
                                                      "cart",
                                                    )
                                                    .then((value) {
                                                      FlushBarMessages.successMessageFlushBar(
                                                        "Product Added to cart successfully",
                                                        // ignore: use_build_context_synchronously
                                                        context,
                                                      );
                                                    })
                                                    .onError((
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      FlushBarMessages.errorMessageFlushBar(
                                                        "Error while adding the product to cart ${error.toString()}",
                                                        // ignore: use_build_context_synchronously
                                                        context,
                                                      );
                                                    });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ), // chhoti padding
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12,
                                                    ), // halka curve
                                              ),
                                              child: Text(
                                                isPresent
                                                    ? "Added to cart"
                                                    : "Add to cart",
                                                style: GoogleFonts.dmSans(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
        ),
      ),
    );
  }
}
