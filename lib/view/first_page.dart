// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rentapp/components/custom_button.dart';
import 'package:rentapp/components/responsive.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/sign_up/signup.dart';
import 'package:rentapp/view/home_page.dart';
import 'package:rentapp/view/login/login.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 20.0),

            child: GestureDetector(
              onTap: () {
                Get.to(() => HomePage());
              },
              child: Row(
                children: [
                  Text(
                    'Continue as guest',
                    style: TextStyle(
                      color: igBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  height: getScreenPropotionHeight(
                    orientation == Orientation.portrait ? 390 : 450,
                    size,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/house.svg',
                      height: getScreenPropotionHeight(100, size),
                      width: getScreenPropotionHeight(200, size),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CustomerAppButton(
                        title: 'Create Account',
                        url: CreateAccount(),
                        color: Colors.white,
                        colorTitle: igLine,
                      ),
                      SizedBox(height: 20),
                      CustomerAppButton(
                        title: 'Login',
                        url: LoginPage(),
                        color: igBlue,
                      ),
                      SizedBox(height: kDefaultPadding / 2),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: igText2),
                            children: [
                              TextSpan(
                                text: "By skipping, you accept our company’s ",
                              ),
                              TextSpan(
                                text: 'Term & conditions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: igText2,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy policies.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: igText2,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: kDefaultPadding / 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
