import 'package:ecommerce_app_my/controllers/faqs_controller.dart';
import 'package:ecommerce_app_my/models/faq_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/widgets/dropdown_field_widget.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_button.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class AddFaqsView extends StatefulWidget {
  const AddFaqsView({super.key});

  @override
  State<AddFaqsView> createState() => _AddFaqsViewState();
}

class _AddFaqsViewState extends State<AddFaqsView> {
  final FaqsOrOrdersController _controller = Get.put(FaqsOrOrdersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Add FAQ",
                style: GoogleFonts.dmSans(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFieldWidget(
                controller: _controller.questionController.value,
                hintText: "Enter faq question",
                title: "FAQ Question",
                suffixIcon: Icons.done,
              ),
              const SizedBox(height: 30),
              TextFieldWidget(
                controller: _controller.answerController.value,
                hintText: "Enter faq answer",
                title: "FAQ Answer",
                suffixIcon: Icons.done,
              ),
              const SizedBox(height: 30),
              DropdownFieldWidget(
                onChanged: (value) {
                  _controller.selectedType.value = value!;
                },
                items: [
                  "General",
                  'Account related',
                  'Payment and Refund',
                  'Product and delievery',
                ],
                title: "FAQ Type",
              ),
              const SizedBox(height: 50),
              Obx(() {
                return ReusableButton(
                  onPress: () {
                    if (_controller.answerController.value.text.isEmpty ||
                        _controller.questionController.value.text.isEmpty ||
                        _controller.selectedType.value.isEmpty) {
                      FlushBarMessages.errorMessageFlushBar(
                        "All Fields should be filled",
                        context,
                      );
                    } else {
                      FaqModel model = FaqModel(
                        adminId: FirebaseAuth.instance.currentUser!.uid,
                        answer: _controller.answerController.value.text
                            .trim()
                            .toString(),
                        id: Uuid().v4(),
                        question: _controller.questionController.value.text
                            .trim()
                            .toString(),
                        type: _controller.selectedType.value.trim().toString(),
                      );
                      _controller
                          .addFaqOrOrders(context, model, "faqs")
                          .then((value) {
                            FlushBarMessages.successMessageFlushBar(
                              "Successfully added faq",
                              // ignore: use_build_context_synchronously
                              context,
                            );
                            // Delay navigation so flushbar visible ho
                            Future.delayed(const Duration(seconds: 1), () {
                              Get.back();
                            });
                            _controller.answerController.value.clear();
                            _controller.questionController.value.clear();
                            _controller.selectedType.value = '';
                          })
                          .onError((error, stackTrace) {
                            FlushBarMessages.errorMessageFlushBar(
                              "Error while adding the faq is ${error.toString()}",
                              // ignore: use_build_context_synchronously
                              context,
                            );
                          });
                    }
                  },
                  title: "Add FAQ",
                  isLoading: _controller.isLoading.value,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
