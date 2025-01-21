import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import '../design_system/app_icons.dart';

class GreenFieldCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width; // 너비 파라미터
  final double height; // 높이 파라미터

  const GreenFieldCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width, // 파라미터로 받은 너비 사용
        height: height, // 파라미터로 받은 높이 사용
        fit: BoxFit.cover,
        placeholder: (context, url) => SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Container(
              width: width,
              height: height,
              color: Colors.transparent,
              child: Lottie.asset(
                'assets/lotties/image_loading.json',
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
    );
  }
}
