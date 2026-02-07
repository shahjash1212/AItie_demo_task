import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String description) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(errorSnackBar(description: description));
}

SnackBar errorSnackBar({required String description}) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(description)],
      ),
    ),
  );
}
