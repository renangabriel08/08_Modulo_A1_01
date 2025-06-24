import 'package:flutter/material.dart';

class MyToast {
  static get(BuildContext context, String txt) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(txt)));
  }
}
