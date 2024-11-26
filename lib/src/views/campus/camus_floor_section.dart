import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_icons.dart';
import '../../design_system/app_texts.dart';
import '../../model/campus.dart';

class CampusFloorSection extends StatelessWidget {
  const CampusFloorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: CampusExample().gwanack.floorDescription!.entries.map((entry) {
          String floor = entry.key;
          List<String> imageAssets = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                floor,
                style: AppTextsTheme.main().gfBody2.copyWith(
                  color: AppColorsTheme().gfBlackColor,
                ),
              ),
              SizedBox(height: 4), // 텍스트와 이미지 사이의 간격
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: imageAssets.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
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
