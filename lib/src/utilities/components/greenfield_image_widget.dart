import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/components/greenfield_cached_network_image.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'dart:io';
import '../../cores/image_type/image_type.dart';
import '../../viewmodels/notice/notice_edit_view_model.dart';
import '../enums/feature_type.dart';
import '../extensions/image_dimension_parser.dart';

class GreenFieldImageWidget extends ConsumerStatefulWidget {
  final List<ImageType> tempImages;
  final FeatureType type;

  const GreenFieldImageWidget({
    super.key,
    required this.tempImages,
    required this.type,
  });
  @override
  GreenFieldImageWidgetState createState() => GreenFieldImageWidgetState();
}

class GreenFieldImageWidgetState extends ConsumerState<GreenFieldImageWidget> {
  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(noticeEditViewModelProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.tempImages.asMap().entries.map((entry) {
          int index = entry.key; // 현재 인덱스
          ImageType image = entry.value; // ImageType 객체

          switch (image) {
            case UrlImage(:final value):
            // TODO: Handle this case.
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GreenFieldCachedNetworkImage(imageUrl: value, width: 120, height: 120, scaleEffect: ImageDimensionParser().parseDimensions(value))
                    ),
                    if(widget.type != FeatureType.campus)
                      CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          editState.removeImage(widget.tempImages, index);
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).appColors.gfWarningColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case XFileImage(:final value):
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(value.path), // Convert XFile to File
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if(widget.type != FeatureType.campus)
                      CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          editState.removeImage(widget.tempImages, index);
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).appColors.gfWarningColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
          }
        }).toList(),
      ),
    );
  }
}
