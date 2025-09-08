import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/cart_model.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
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
                  "My Cart",
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
                      final cartList = snapshot.data!.docs
                          .map((json) => CartModel.fromJson(json.data()))
                          .toList();

                          if(cartList.isEmpty){
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Your cart is empty",
                                  style: GoogleFonts.dmSans(color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),),
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
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                              cartProduct
                                                  .productModel
                                                  .imageUrls
                                                  .first,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(cartProduct.productModel.title,
                                            style: GoogleFonts.dmSans(color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),),
                                               Text(cartProduct.productModel.subtitle,
                                            style: GoogleFonts.dmSans(color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),),
                                            const SizedBox(height: 10,),
                                               Text(cartProduct.productModel.price,
                                            style: GoogleFonts.dmSans(color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // chhoti padding
  decoration: BoxDecoration(
    color: const Color(0xffEEEEEE),
    borderRadius: BorderRadius.circular(12), // halka curve
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
          size: 16, // chhoti icon size
          color: Colors.black,
        ),
      ),
      const SizedBox(width: 6),
      Text(
        cartProduct.quantity.toString(),
        style: GoogleFonts.dmSans(
          color: Colors.black,
          fontSize: 14, // readable but chhota
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
          size: 16, // chhoti icon size
          color: Colors.black,
        ),
      ),
    ],
  ),
)

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
