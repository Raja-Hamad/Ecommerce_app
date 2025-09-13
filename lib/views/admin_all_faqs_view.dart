import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/faq_model.dart';
import 'package:ecommerce_app_my/views/add_faqs_view.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAllFaqsView extends StatefulWidget {
  const AdminAllFaqsView({super.key});

  @override
  State<AdminAllFaqsView> createState() => _AdminAllFaqsViewState();
}

class _AdminAllFaqsViewState extends State<AdminAllFaqsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddFaqsView()));
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("faqs")
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
                      List<FaqModel> generalFaqsList = snapshots.data!.docs
                          .where((generalFaq) => generalFaq['type'] == "General")
                          .map((json) => FaqModel.fromJson(json.data()))
                          .toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                  "General asked questions",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                          ListView.builder(
                            itemCount: generalFaqsList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final generalFaq=generalFaqsList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  
                                    Container(
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Question: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: generalFaq.question,
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Answer: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: generalFaq.answer,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                 const SizedBox(height: 30),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("faqs")
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
                      List<FaqModel> accountRelatedList = snapshots.data!.docs
                          .where((generalFaq) => generalFaq['type'] == "Account related")
                          .map((json) => FaqModel.fromJson(json.data()))
                          .toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                  "Account related asked questions",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                          ListView.builder(
                            itemCount: accountRelatedList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final accountRelatedFaq=accountRelatedList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  
                                    Container(
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Question: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: accountRelatedFaq.question,
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Answer: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: accountRelatedFaq.answer,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                 const SizedBox(height: 30),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("faqs")
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
                      List<FaqModel> paymentAndRefundFaqList = snapshots.data!.docs
                          .where((generalFaq) => generalFaq['type'] == "Payment and Refund")
                          .map((json) => FaqModel.fromJson(json.data()))
                          .toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                  "Payment and refund related asked questions",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                          ListView.builder(
                            itemCount: paymentAndRefundFaqList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final paymentAndRefundFaq=paymentAndRefundFaqList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  
                                    Container(
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Question: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: paymentAndRefundFaq.question,
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Answer: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: paymentAndRefundFaq.answer,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                 const SizedBox(height: 30),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("faqs")
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
                      List<FaqModel> productAndDelieveryFaqList = snapshots.data!.docs
                          .where((generalFaq) => generalFaq['type'] == "Product and delievery")
                          .map((json) => FaqModel.fromJson(json.data()))
                          .toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                  "Product and delievery related asked questions",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                          ListView.builder(
                            itemCount: productAndDelieveryFaqList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final productAndDelieveryFaq=productAndDelieveryFaqList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  
                                    Container(
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Question: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: productAndDelieveryFaq.question,
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                            RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Answer: ",
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: productAndDelieveryFaq.answer,
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
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
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
