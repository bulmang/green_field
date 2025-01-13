import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GreenFieldLoadingWidget extends StatelessWidget {
  final double size;

  const GreenFieldLoadingWidget({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.2),
        ),
        Center(
          child: Container(
            width: size,
            height: size,
            color: Colors.transparent,
            child: Lottie.asset(
              'assets/lotties/loading.json',
              repeat: true,
              animate: true,
            ),
          ),
        ),
      ],
    );
  }
}
