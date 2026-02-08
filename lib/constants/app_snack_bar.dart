import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String description) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar(description: description));
}

SnackBar snackBar({required String description}) {
  return SnackBar(
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    content: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(description, style: TextStyle(fontSize: 12))],
      ),
    ),
  );
}
