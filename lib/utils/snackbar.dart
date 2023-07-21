// import 'package:flutter/material.dart';

// void mySnackBar(BuildContext context, String text) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
// }

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
