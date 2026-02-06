import 'package:flutter/material.dart';

class GapW extends StatelessWidget {
  final double width;

  const GapW(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class GapH extends StatelessWidget {
  final double height;

  const GapH(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
