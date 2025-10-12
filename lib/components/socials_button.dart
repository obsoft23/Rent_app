// ignore_for_file: unused_field, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  SocialButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    this.color,
    this.textColor,
  });

  var onTap;
  var icon;
  var text;
  var color;
  var textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            /* SvgPicture.asset(
              "assets/icons/google.svg",
            ),*/
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
