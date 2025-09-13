import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/order_model.dart';
import 'package:ecommerce_app_my/views/edit_delievery_address.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyShippingAddressView extends StatefulWidget {
  const MyShippingAddressView({super.key});

  @override
  State<MyShippingAddressView> createState() => _MyShippingAddressViewState();
}

class _MyShippingAddressViewState extends State<MyShippingAddressView> {
  AddressModel? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditDelieveryAddress(addressModel: selectedAddress!),
              ),
            );
          },
          child: Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Update Delievery Address",
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
