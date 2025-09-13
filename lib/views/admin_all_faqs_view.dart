import 'package:ecommerce_app_my/views/add_faqs_view.dart';
import 'package:flutter/material.dart';

class AdminAllFaqsView extends StatefulWidget {
  const AdminAllFaqsView({super.key});

  @override
  State<AdminAllFaqsView> createState() => _AdminAllFaqsViewState();
}

class _AdminAllFaqsViewState extends State<AdminAllFaqsView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
