import 'package:ecommerce_app_my/utils/extensions/local_storage.dart';
import 'package:ecommerce_app_my/views/update_profile_view.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_button.dart';
import 'package:ecommerce_app_my/views/widgets/reusable_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalDetailsView extends StatefulWidget {
  const PersonalDetailsView({super.key});

  @override
  State<PersonalDetailsView> createState() => _PersonalDetailsViewState();
}

class _PersonalDetailsViewState extends State<PersonalDetailsView> {
  final LocalStorage _localStorage = LocalStorage();
  String? name;
  String? imageUrl;
  String? emailAddress;
  void getValues() async {
    name = await _localStorage.getValue("userName");
    emailAddress = await _localStorage.getValue("email");
    imageUrl = await _localStorage.getValue("imageUrl");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      imageUrl!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                ReusableContainerWidget(
                  title: "Name",
                  conrainerText: name ?? "",
                ),
                const SizedBox(height: 16),
                ReusableContainerWidget(
                  conrainerText: emailAddress ?? "",
                  title: "Email",
                ),

                const SizedBox(height: 40),
                ReusableButton(
                  title: "Update Profile",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileView(
                          imageUrl: imageUrl ?? "",
                          email: emailAddress ?? "",
                          name: name ?? "",
                        ),
                      ),
                    );
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
