import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import '../design_system/app_icons.dart';

class GreenFieldCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final bool activeFitWidth;

  const GreenFieldCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.activeFitWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: (activeFitWidth) ? BoxFit.fitWidth : BoxFit.fitHeight,
        placeholder: (context, url) => SizedBox(
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
        imageBuilder: (context, imageProvider) {
          // Resolve the image to get its dimensions
          imageProvider.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (ImageInfo info, bool _) {
                print(
                    'Loaded image from $imageUrl: ${info.image.width}x${info.image.height}');
              },
            ),
          );
          return Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: (activeFitWidth) ? BoxFit.fitWidth : BoxFit.fitHeight,
          );
        },
        errorWidget: (context, url, error) => Image.asset(
          AppIcons.seatingSesac,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
