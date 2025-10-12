// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, unused_field, unused_element, unused_import, prefer_const_constructors_in_immutables, prefer_final_fields, unused_local_variable, duplicate_ignore

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class CenterLoadingIndicator extends StatelessWidget {
  const CenterLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 23,
            child: Image.asset("assets/images/loading.gif"),
          ),
        ],
      ),
    );
  }
}
