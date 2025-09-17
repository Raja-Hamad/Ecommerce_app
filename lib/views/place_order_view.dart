import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/controllers/faqs_controller.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/models/order_model.dart';
import 'package:ecommerce_app_my/models/user_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class PlaceOrderView extends StatefulWidget {
  String adminId;
  int totalAmount;
  PlaceOrderView({super.key, required this.totalAmount, required this.adminId});

  @override
  State<PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  Future<void> clearUserCart(String userId) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    final cartSnapshot = await cartRef.get();

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  AddressModel? selectedAddress;
  List<CartModel> cartList = [];

  final FaqsOrOrdersController _faqsOrOrdersController = Get.put(
    FaqsOrOrdersController(),
  );
  final LocalStorage _localStorage = LocalStorage();
  String? name;
  String? imageUrl;
  String? emailAddress;
  String? userDeviceToken;
  bool isLoading = true;

  void getValues() async {
    name = await _localStorage.getValue("userName");
    emailAddress = await _localStorage.getValue("email");
    imageUrl = await _localStorage.getValue("imageUrl");
    userDeviceToken = await _localStorage.getValue("userDeviceToken");
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
    return Scaffold(
      bottomNavigationBar: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("cart")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }

          final cartList = snapshot.data!.docs
              .map((json) => CartModel.fromJson(json.data()))
              .toList();

          int total = 0;
          for (var product in cartList) {
            total += product.productModel.price * product.quantity!;
          }
          if (cartList.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTap: () async {
                  UserModel userModel = UserModel(
                    email: emailAddress ?? "",
                    imageUrl: imageUrl ?? "",
                    userDeviceToken: userDeviceToken ?? "",
                    userName: name ?? "",
                    id: FirebaseAuth.instance.currentUser!.uid,
                  );
                  OrderModel orderModel = OrderModel(
                    userModel: userModel,
                    adminId: widget.adminId,
                    addressModel: selectedAddress!,
                    cartModel: cartList,
                    id: Uuid().v4(),
                    paymentMethod: "Cash On Delievery(COD)",
                    paymentStatus: "Unpaid",
                    status: 'Pending',
                    totalAmount: widget.totalAmount,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  );
                  _faqsOrOrdersController
                      .addFaqOrOrders(context, orderModel, "orders")
                      .then((value) async {
                        await clearUserCart(
                          FirebaseAuth.instance.currentUser!.uid,
                        );
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _faqsOrOrdersController.isLoading.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Price",
                                    style: GoogleFonts.dmSans(
                                      color: Color(0xffD5D5D5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "\$${widget.totalAmount.toString()}",
                                    style: GoogleFonts.dmSans(
                                      color: Color(0xff000000),
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
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Place Order",
                                      style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
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
                                    const SizedBox(height: 100),
                                    SvgPicture.asset(
                                      "assets/svgs/nothing_found.svg",
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      'No Cart Item found.',
                                      style: GoogleFonts.dmSans(
                                        color: Color(0xff000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Start adding items to the cart',
                                      style: GoogleFonts.openSans(
                                        color: Color(0xff000000),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
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
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "\$${cartProduct.productModel.price.toString()}",
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
