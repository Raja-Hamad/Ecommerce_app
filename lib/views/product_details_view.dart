import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/controllers/add_to_cart_or_wishlist_controller.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/models/product_model.dart';
import 'package:ecommerce_app_my/models/wishlist_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ProductDetailsView extends StatefulWidget {
  ProductModel model;
  ProductDetailsView({super.key, required this.model});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final AddToCartOrWishlistController _cartController = Get.put(
    AddToCartOrWishlistController(),
  );

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int productCout = 1;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Product data is ${widget.model}");
    }
  }

  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.39,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xffF2F2F2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(),
                          const SizedBox(),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Image swiper
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.model.imageUrls.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                widget.model.imageUrls[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Dots + Fav icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.model.imageUrls.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? Colors.black
                                      : Colors.grey, // active/inactive
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
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
                                return const SizedBox();
                              } else {
                                final cartList = snapshot.data!.docs
                                    .map(
                                      (json) =>
                                          WishlistModel.fromJson(json.data()),
                                    )
                                    .toList();

                                bool isPresent = cartList.any(
                                  (product) =>
                                      product.productModel.id ==
                                      widget.model.id,
                                );
                                return GestureDetector(
                                  onTap: () {
                                    if (isPresent) {
                                      FlushBarMessages.successMessageFlushBar(
                                        "This product is already in Wishlist",
                                        context,
                                      );
                                    } else {
                                      WishlistModel model = WishlistModel(
                                        id: Uuid().v4(),
                                        productModel: widget.model,
                                      );
                                      _cartController
                                          .addToCartOrWishList(
                                            context,
                                            model,
                                            "wishList",
                                          )
                                          .then((value) {
                                            FlushBarMessages.successMessageFlushBar(
                                              "Product added to wishlist successfully",
                                              // ignore: use_build_context_synchronously
                                              context,
                                            );
                                          })
                                          .onError((error, stackTrace) {
                                            FlushBarMessages.errorMessageFlushBar(
                                              "Error while adding the product to wishlist is ${error.toString()}",
                                              // ignore: use_build_context_synchronously
                                              context,
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: !isPresent
                                        ? Icon(
                                            Icons.favorite_outline,
                                            color: Colors.black,
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.black,
                                            size: 20,
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
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.model.title,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.model.subtitle,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEEEEEE),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (productCout > 1) {
                                              setState(() {
                                                productCout--;
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          productCout.toString(),
                                          style: GoogleFonts.dmSans(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              productCout++;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Available in Stock",
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
                        const SizedBox(height: 20),
                        Text(
                          "Description",
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.model.description,
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Sizes row
                        Text(
                          "Available Sizes",
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.model.sizes.split(",").length,
                            itemBuilder: (context, index) {
                              final size = widget.model.sizes
                                  .split(",")[index]
                                  .trim(); // remove spaces
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Price',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  widget.model.price,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                        (json) =>
                                            CartModel.fromJson(json.data()),
                                      )
                                      .toList();

                                  bool isPresent = cartList.any(
                                    (product) =>
                                        product.productModel.id ==
                                        widget.model.id,
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
                                          productModel: widget.model,
                                          quantity: productCout,
                                        );

                                        _cartController
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
                                            .onError((error, stackTrace) {
                                              FlushBarMessages.errorMessageFlushBar(
                                                "Error while adding the product to cart ${error.toString()}",
                                                // ignore: use_build_context_synchronously
                                                context,
                                              );
                                            });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xff000000),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        child:  Row(
                                                children: [
                                                  Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    isPresent?"Added to cart":"Add to cart",
                                                    style: GoogleFonts.dmSans(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
