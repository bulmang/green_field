import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:green_field/src/utilities/design_system/app_colors.dart';
import 'package:lottie/lottie.dart';
import '../design_system/app_icons.dart';

class GreenFieldCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width; // 너비 파라미터
  final double height; // 높이 파라미터
  final double? scaleEffect;

  const GreenFieldCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.scaleEffect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child:Transform.scale(
        scale: (scaleEffect != null) ? scaleEffect : 1.0,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width, // 파라미터로 받은 너비 사용
          height: height, // 파라미터로 받은 높이 사용
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => Container(
            child: SizedBox(
              width: width,
              height: height,
              child: Center(
                child: Lottie.asset(
                  fit: BoxFit.fitWidth,
                  'assets/lotties/box_loading.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            AppIcons.seatingSesac, // 에셋 이미지로 대체
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
