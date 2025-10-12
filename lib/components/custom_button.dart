// ignore_for_file: prefer_const_constructors, unused_import, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:rentapp/theme/theme.dart';

import '../theme/constants.dart';

class CustomerAppButton extends StatelessWidget {
  CustomerAppButton({
    super.key,
    required this.title,
    required this.url,
    required this.color,
    colorTitle,
  });

  String title = "";

  var url;
  var color;
  var colorTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(url);
      },
      child: Container(
        width: double.infinity,
        height: 56.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: colorTitle,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 
