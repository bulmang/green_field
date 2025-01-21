import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
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
            decoration: BoxDecoration(
              color: AppColorsTheme.main().gfWhiteColor,
              shape: BoxShape.circle, // 원형으로 설정
            ),
            child: ClipOval(
              child: Lottie.asset(
                'assets/lotties/loading.json',
                repeat: true,
                animate: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
