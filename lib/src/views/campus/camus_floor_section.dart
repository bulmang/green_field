import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../utilities/components/greenfield_cached_network_image.dart';
import '../../utilities/components/greenfield_images_detail.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../model/campus.dart';
import '../../utilities/extensions/image_dimension_parser.dart';
import '../../viewmodels/campus/campus_view_model.dart';

class CampusFloorSection extends ConsumerStatefulWidget {
  const CampusFloorSection({super.key});

  @override
  ConsumerState<CampusFloorSection> createState() => _CampusFloorSectionState();
}

class _CampusFloorSectionState extends ConsumerState<CampusFloorSection> {
  @override
  Widget build(BuildContext context) {
    final campusState = ref.watch(campusViewModelProvider);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: campusState.value!.floorDescription!.entries.map((entry) {
          String floor = entry.key;
          List<String> imageAssets = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                floor,
                style: AppTextsTheme.main().gfBody2.copyWith(
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
              ),
              SizedBox(height: 4), // 텍스트와 이미지 사이의 간격
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageAssets.asMap().entries.map((entry) {
                    int index = entry.key;
                    String? imageUrl = entry.value;
                    if (imageUrl != null) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    GreenFieldImagesDetail(
                                      tags: imageAssets,
                                      initialIndex: index,
                                    ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: imageUrl,
                            child: GreenFieldCachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 120,
                                height: 120,
                                scaleEffect: 2,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

