// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/theme/theme.dart';

class SignInButtonWidget extends StatelessWidget {
  var buttonImage;
  var url;
  String buttonText = "";

  SignInButtonWidget({
    super.key,
    required this.buttonImage,
    required this.buttonText,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(url);
      },
      // ignore: deprecated_member_use
      splashColor: Colors.brown.withOpacity(0.2),
      child: Ink(
        width: double.infinity,
        height: 56.0,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            // color: Colors.,
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 23,
              height: 23,
              child: buttonImage,
            ),
            Spacer(),
            Text(
              buttonText,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
