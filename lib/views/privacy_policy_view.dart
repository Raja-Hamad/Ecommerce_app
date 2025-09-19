import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Last updated: September 19, 2025\n",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Welcome to our Ecommerce App. We value your trust and are committed "
                "to protecting your privacy. This Privacy Policy explains how we collect, "
                "use, and safeguard your information when you use our application.",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "1. Information We Collect",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "• Personal Information (name, email, phone number)\n"
                "• Device Information (device type, OS version)\n"
                "• Usage Data (pages visited, time spent)\n",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "2. How We Use Your Information",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We use your information to:\n"
                "• Provide and improve our services\n"
                "• Process transactions securely\n"
                "• Send important updates and notifications\n"
                "• Enhance user experience",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "3. Data Security",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We implement strict security measures to protect your data from "
                "unauthorized access, alteration, or disclosure.",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "4. Third-Party Services",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Our app may contain links to third-party services. We are not "
                "responsible for their privacy practices. Please review their "
                "policies separately.",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "5. Changes to This Policy",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We may update this Privacy Policy from time to time. We encourage "
                "you to review it periodically.",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "6. Contact Us",
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "If you have any questions about this Privacy Policy, please contact us "
                "at support@ecommerceapp.com",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  "© 2025 Ecommerce App. All rights reserved.",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
