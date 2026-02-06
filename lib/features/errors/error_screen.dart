import 'package:aitie_demo/constants/app_buttons.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  const ErrorScreen({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'An unexpected error occurred. Please try again.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Colors.red.shade400,
                ),
                const GapH(16),
                Text(message, textAlign: TextAlign.center),
                const GapH(24),
                SizedBox(
                  width: 150,
                  child: AppButtonBorder(onTap: () {}, text: 'Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
