import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_my/models/notification_model.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_shimmer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {

// @override
// void initState() {
//   super.initState();

//   /// jaise hi screen khule -> unread notifications ko read kar do
//   FirebaseFirestore.instance
//       .collection("notifications")
//       .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//       .where("notificationReadStatus", isEqualTo: "unread")
//       .get()
//       .then((querySnapshot) {
//     for (var doc in querySnapshot.docs) {
//       doc.reference.update({
//         "notificationReadStatus": "read",
//       });
//     }
//   });
// }

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      body: Scaffold(
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
                    "All Notifications",
                    style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  StreamBuilder(
                    stream: stream,
                    builder: (context, snaphots) {
                      if (snaphots.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return const ReusableShimmerWidget();
                          },
                        );
                      } else if (snaphots.data == null || !snaphots.hasData) {
                        return const SizedBox();
                      } else {
                        List<NotificationModel> allNotificationsList = snaphots
                            .data!
                            .docs
                            .map(
                              (notification) => NotificationModel.fromJson(
                                notification.data(),
                              ),
                            )
                            .toList();
                        return ListView.builder(
                          itemCount: allNotificationsList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final notification = allNotificationsList[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Order Id: ",

                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: notification.orderId,

                                          style: GoogleFonts.dmSans(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            notification.productImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Product info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              notification.productName,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notification.notificationTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              notification.notificationBody,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        child: Center(
                                          child: Text(
                                            notification.orderStatus,
                                            style: GoogleFonts.dmSans(
                                              color: Colors
                                                  .white, // 🔹 Fix color (white text on black background)
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
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
      ),
    );
  }
}
