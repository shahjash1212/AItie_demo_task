import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: RetryButton(
                    onRetry: () {
                      GoRouter.of(context).canPop()
                          ? GoRouter.of(context).pop()
                          : GoRouter.of(context).go(RouteNames.product);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.onRetry});
  final Function onRetry;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onRetry(),

      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: const Text(
        'Retry',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
