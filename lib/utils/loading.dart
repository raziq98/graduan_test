
import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  final double? stroke;
  const LoadingAnimation({super.key, this.stroke});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: stroke ?? 4.0,
    );
  }
}
