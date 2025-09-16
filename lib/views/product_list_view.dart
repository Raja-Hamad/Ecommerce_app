import 'package:ecommerce_app_my/controllers/product_controller.dart';
import 'package:ecommerce_app_my/models/product_model.dart';
import 'package:ecommerce_app_my/views/product_details_view.dart';
import 'package:ecommerce_app_my/views/widgets/products_list_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProductListView extends StatefulWidget {
  String title;
  List<ProductModel> listOfProduct;
  ProductListView({
    super.key,
    required this.listOfProduct,
    required this.title,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductController _controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("All products list is ${widget.listOfProduct}");
      print("All products list length is ${widget.listOfProduct.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                widget.title,
                style: GoogleFonts.dmSans(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ProductsListTextfield(
                controller: _controller.productListViewController.value,
                hintText: "Search Categories",
                leadingIcon: Icons.search,
              ),
              const SizedBox(height: 20),
              widget.listOfProduct.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          SvgPicture.asset("assets/svgs/nothing_found.svg"),
                          const SizedBox(height: 30),
                          Text(
                            'No Product found',
                            style: GoogleFonts.dmSans(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'We will notify you when any product available,',
                            style: GoogleFonts.openSans(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    )
                  :
                    /// GridView for Products
                    Expanded(
                      child: GridView.builder(
                        itemCount: widget.listOfProduct.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 10,
                              childAspectRatio:
                                  0.9, // adjust as per your design
                            ),
                        itemBuilder: (context, index) {
                          final product = widget.listOfProduct[index];
                          final imageUrl = product.imageUrls.first;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsView(model: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Sirf image wala container
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xffF2F2F2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Title text
                                Text(
                                  product.title,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 4),

                                // Subtitle text
                                Text(
                                  product.subtitle,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
