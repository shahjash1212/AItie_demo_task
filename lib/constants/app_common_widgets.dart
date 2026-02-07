import 'package:flutter/material.dart';

class AppRefreshIndecator extends StatelessWidget {
  const AppRefreshIndecator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.isDark = false,
  });
  final Future<void> Function() onRefresh;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 23});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
