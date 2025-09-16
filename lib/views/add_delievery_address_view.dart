import 'package:ecommerce_app_my/controllers/add_to_cart_or_wishlist_controller.dart';
import 'package:ecommerce_app_my/models/order_model.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/place_order_view.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class AddDelieveryAddressView extends StatefulWidget {
  String adminId;
  int totalAmount;
  AddDelieveryAddressView({
    super.key,
    required this.adminId,
    required this.totalAmount,
  });

  @override
  State<AddDelieveryAddressView> createState() =>
      _AddDelieveryAddressViewState();
}

class _AddDelieveryAddressViewState extends State<AddDelieveryAddressView> {
  final AddToCartOrWishlistController _addToCartOrWishlistController = Get.put(
    AddToCartOrWishlistController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          return GestureDetector(
            onTap: () async {
              if (_addToCartOrWishlistController
                      .callingCodeController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .cityController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .countryCodeController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .countryController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .fullAddressController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .nameController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .phoneController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .stateController
                      .value
                      .text
                      .isNotEmpty &&
                  _addToCartOrWishlistController
                      .zipCodeController
                      .value
                      .text
                      .isNotEmpty) {
                AddressModel addressModel = AddressModel(
                  city:
                      _addToCartOrWishlistController.cityController.value.text,
                  fullAddress: _addToCartOrWishlistController
                      .fullAddressController
                      .value
                      .text,
                  name:
                      _addToCartOrWishlistController.nameController.value.text,
                  phone:
                      _addToCartOrWishlistController.phoneController.value.text,
                  callingCode: _addToCartOrWishlistController
                      .callingCodeController
                      .value
                      .text,
                  country: _addToCartOrWishlistController
                      .countryController
                      .value
                      .text,
                  state:
                      _addToCartOrWishlistController.stateController.value.text,
                  zipCode: _addToCartOrWishlistController
                      .zipCodeController
                      .value
                      .text,
                  countryCode: _addToCartOrWishlistController
                      .countryCodeController
                      .value
                      .text,
                  id: Uuid().v4(),
                );

                _addToCartOrWishlistController
                    .addToCartOrWishList(
                      context,
                      addressModel,
                      "delievery_address",
                    )
                    .then((value) {
                      // ✅ Clear all controllers after success
                      _addToCartOrWishlistController.callingCodeController.value
                          .clear();
                      _addToCartOrWishlistController.cityController.value
                          .clear();
                      _addToCartOrWishlistController.countryCodeController.value
                          .clear();
                      _addToCartOrWishlistController.countryController.value
                          .clear();
                      _addToCartOrWishlistController.fullAddressController.value
                          .clear();
                      _addToCartOrWishlistController.nameController.value
                          .clear();
                      _addToCartOrWishlistController.phoneController.value
                          .clear();
                      _addToCartOrWishlistController.stateController.value
                          .clear();
                      _addToCartOrWishlistController.zipCodeController.value
                          .clear();

                      // ✅ Navigate
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceOrderView(
                            adminId: widget.adminId,
                            totalAmount: widget.totalAmount,
                          ),
                        ),
                      );

                      // ✅ Success Message
                      FlushBarMessages.successMessageFlushBar(
                        "Successfully added delivery address",
                        // ignore: use_build_context_synchronously
                        context,
                      );
                    });
              } else {
                FlushBarMessages.errorMessageFlushBar(
                  "All Fields should be filled",
                  context,
                );
              }
            },
            child: Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _addToCartOrWishlistController.isLoading.value
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Add Delivery Address",
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          );
        }),
      ),

      resizeToAvoidBottomInset: true,
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
                  "Delievery Address",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.nameController.value,
                  hintText: 'Enter your name',
                  suffixIcon: Icons.done,
                  title: "Name",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.phoneController.value,
                  hintText: 'Enter your phone',
                  suffixIcon: Icons.done,
                  title: "Phone",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.cityController.value,
                  hintText: 'Enter your city',
                  suffixIcon: Icons.done,
                  title: "City",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _addToCartOrWishlistController
                      .fullAddressController
                      .value,
                  hintText: 'Street number, town, city, country',
                  suffixIcon: Icons.done,
                  title: "Full Address",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _addToCartOrWishlistController
                      .countryCodeController
                      .value,
                  hintText: 'Enter your Country code',
                  suffixIcon: Icons.done,
                  title: "Country Code",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.zipCodeController.value,
                  hintText: 'Enter your zip code',
                  suffixIcon: Icons.done,
                  title: "Zip code",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.stateController.value,
                  hintText: 'Enter your state',
                  suffixIcon: Icons.done,
                  title: "State",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _addToCartOrWishlistController
                      .callingCodeController
                      .value,
                  hintText: 'Enter your calling code',
                  suffixIcon: Icons.done,
                  title: "Calling code",
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller:
                      _addToCartOrWishlistController.countryController.value,
                  hintText: 'Enter your country',
                  suffixIcon: Icons.done,
                  title: "Country",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
