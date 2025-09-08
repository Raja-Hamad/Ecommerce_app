import 'package:ecommerce_app_my/controllers/product_controller.dart';
import 'package:ecommerce_app_my/utils/extensions/flushbar_messaging.dart';
import 'package:ecommerce_app_my/views/bottom_nav_bar.dart';
import 'package:ecommerce_app_my/views/widgets/dropdown_field_widget.dart';
import 'package:ecommerce_app_my/views/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ProductController _controller = Get.put(ProductController());

  disposeValues() {
    _controller.productTitleController.value.clear();
    _controller.productSubtitleController.value.clear();
    _controller.productPriceController.value.clear();
    _controller.productDexcriptionController.value.clear();
    _controller.productSizesController.value.clear();
    _controller.availableProductStock.value.clear();
    _controller.selectedImages.value = [];
    _controller.selectedCategory.value = 'Select Category';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Obx(() {
          return GestureDetector(
            onTap: () async {
              if (_controller.productDexcriptionController.value.text.isEmpty &&
                  _controller.productPriceController.value.text.isEmpty &&
                  _controller.productSizesController.value.text.isEmpty &&
                  _controller.productSubtitleController.value.text.isEmpty &&
                  _controller.productTitleController.value.text.isEmpty &&
                  _controller.selectedImages.isEmpty &&
                  _controller.selectedCategory.value.isEmpty) {
                FlushBarMessages.errorMessageFlushBar(
                  "Kindly fill all fields",
                  context,
                );
              } else if (_controller.selectedImages.length > 3) {
                FlushBarMessages.errorMessageFlushBar(
                  "Maximum 3 product images are allowed",
                  context,
                );
              } else {
              
                _controller
                    // ignore: use_build_context_synchronously
                    .addProduct(
                      category: _controller.selectedCategory.value
                          .trim()
                          .toString(),
                      price: _controller.productPriceController.value.text
                          .trim()
                          .toString(),
                      productSizes: _controller
                          .productSizesController
                          .value
                          .text
                          .trim()
                          .toString(),
                      subtitle: _controller.productSubtitleController.value.text
                          .trim()
                          .toString(),
                      title: _controller.productTitleController.value.text
                          .trim()
                          .toString(),
                      description: _controller
                          .productDexcriptionController
                          .value
                          .text
                          .trim()
                          .toString(),
                      context: context,
                      totalStock: _controller.availableProductStock.value.text
                          .trim()
                          .toString(),
                    )
                    .then((value) {
                      disposeValues();
                      FlushBarMessages.successMessageFlushBar(
                        "Successfully Added Product",
                        // ignore: use_build_context_synchronously
                        context,
                      );
                      Get.to(BottomNavBarView());
                    })
                    .onError((error, stackTrace) {
                      FlushBarMessages.errorMessageFlushBar(
                        "Error while adding product is ${error.toString()}",
                        // ignore: use_build_context_synchronously
                        context,
                      );
                    });
              }
            },
            child: Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: _controller.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Text(
                        "Add Product",
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
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Add Product",
                  style: GoogleFonts.dmSans(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _controller.pickImagesFromGallery,
                        child: Obx(() {
                          if (_controller.selectedImages.isEmpty) {
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: const Icon(Icons.camera_alt),
                            );
                          } else {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _controller.selectedImages.map((file) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    file,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Upload Product Image",
                        style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.productTitleController.value,
                  hintText: "Enter product title",
                  title: "Name",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.productSubtitleController.value,
                  hintText: "Enter product Subtitle",
                  title: "Subtitle",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.productPriceController.value,
                  hintText: "Enter product Price",
                  title: "Price",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.productDexcriptionController.value,
                  hintText: "Enter product Description",
                  title: "Description",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.productSizesController.value,
                  hintText: "Enter product Sizes",
                  title: "Product Sizes",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _controller.availableProductStock.value,
                  hintText: "Enter product Total Stock",
                  title: "Total Stock",
                  suffixIcon: Icons.done,
                ),
                const SizedBox(height: 20),
                DropdownFieldWidget(
                  title: "Category",
                  items: [
                    "Shoes",
                    "Clothes",
                    "Watches",
                    "Bags",
                    "New Arrivals",
                    "Electronics",
                    "Jewelry",
                  ],
                  onChanged: (value) {
                    _controller.selectedCategory.value = value!;
                    if (kDebugMode) {
                      print("Selected category: $value");
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
