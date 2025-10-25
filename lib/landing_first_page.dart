// ignore_for_file: unused_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rentapp/components/custom_button.dart';
import 'package:rentapp/components/responsive.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/single_main_pages/location_permission.dart';
import 'package:rentapp/view/sign_up/signup.dart';
import 'package:rentapp/view/Home/home_page.dart';
import 'package:rentapp/view/login/login.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/policies_folder/privacy_policy_page.dart';
import 'package:rentapp/view/tab_pages/user_profile_page/policies_folder/terms_of_servicepage.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 20.0),

            child: GestureDetector(
              onTap: () {
                Get.offAll(() => LocationPermissionPage());
              },
              child: Row(
                children: [
                  Text(
                    'Continue as guest',
                    style: TextStyle(
                      color: igBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: igBlue, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: getScreenPropotionHeight(
                      orientation == Orientation.portrait ? 300 : 350,
                      size,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/splash1.svg',
                        height: getScreenPropotionHeight(180, size),
                        width: getScreenPropotionHeight(180, size),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Getting Started",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        CustomerAppButton(
                          title: 'Create Account',
                          url: CreateAccount(),
                          color: Colors.white,
                          colorTitle: igLine,
                        ),
                        SizedBox(height: 12),
                        CustomerAppButton(
                          title: 'Login',
                          url: LoginPage(),
                          color: igBlue,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: igText2),
                              children: [
                                TextSpan(
                                  text:
                                      "By skipping this page, you accept our company’s ",
                                ),
                                TextSpan(
                                  text: 'Term & conditions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: igText2,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle privacy policy tap
                                      Get.to(TermsOfServicePage());
                                    },
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy policies.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: igText2,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle privacy policy tap
                                      Get.to(PrivacyPolicyPage());
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Removed invalid 'children' parameter
    );
  }
}
