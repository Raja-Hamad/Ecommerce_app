import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/controllers/add_to_cart_or_wishlist_controller.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/services/firestore_services.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final AddToCartOrWishlistController _addToCartOrWishlistController = Get.put(
    AddToCartOrWishlistController(),
  );
  final FirestoreServices _firestoreServices = FirestoreServices();

  final cartStream = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("cart")
      .snapshots();

  void updateQuantity(String docId, int newQuantity) async {
    if (newQuantity > 0) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cart")
          .doc(docId)
          .update({"quantity": newQuantity});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ✅ Body ke liye alag StreamBuilder
      body: SafeArea(
        child: StreamBuilder(
          stream: cartStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) => const ReusableShimmerWidget(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "Your cart is empty",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final cartList = snapshot.data!.docs
                .map((json) => CartModel.fromJson(json.data()))
                .toList();

            return buildCartBody(cartList, snapshot);
          },
        ),
      ),

      /// ✅ Bottom bar ke liye alag StreamBuilder
      bottomNavigationBar: StreamBuilder(
        stream: cartStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // ✅ Jab cart empty hai → nav bar hi hide kar do
            return const SizedBox.shrink();
          }

          final cartList = snapshot.data!.docs
              .map((json) => CartModel.fromJson(json.data()))
              .toList();

          int total = cartList.fold(
            0,
            (sum, item) => sum + (item.productModel.price * item.quantity!),
          );

          return buildBottomBar(total,
          cartList.first.productModel.adminId);
        },
      ),
    );
  }

  /// 🔹 Helper: Bottom bar widget
  Widget buildBottomBar(int total, String adminId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GestureDetector(
        onTap: () async {
          _firestoreServices.checkUserAddressAndNavigate(
            context,
            FirebaseAuth.instance.currentUser!.uid,
            total,
            adminId
          );
        },
        child: Container(
          height: 40,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.dmSans(
                      color: const Color(0xffD5D5D5),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "\$$total",
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    "Proceed to Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  /// 🔹 Helper: Cart body widget
  Widget buildCartBody(
    List<CartModel> cartList,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "My Cart",
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            /// 🔹 List of products
            Column(
              children: cartList.map((cartProduct) {
                final docId =
                    snapshot.data!.docs[cartList.indexOf(cartProduct)].id;

                return Dismissible(
                  key: Key(docId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("cart")
                        .doc(docId)
                        .delete();

                    FlushBarMessages.successMessageFlushBar(
                      "${cartProduct.productModel.title} removed from cart",
                      context,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  cartProduct.productModel.imageUrls.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartProduct.productModel.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cartProduct.productModel.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "\$${(cartProduct.productModel.price * cartProduct.quantity!).toString()}",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffEEEEEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  int currentQuantity = cartProduct.quantity!;
                                  if (currentQuantity > 1) {
                                    updateQuantity(docId, currentQuantity - 1);
                                  }
                                },
                                child: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cartProduct.quantity.toString(),
                                style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  int currentQuantity = cartProduct.quantity!;
                                  updateQuantity(docId, currentQuantity + 1);
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
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
