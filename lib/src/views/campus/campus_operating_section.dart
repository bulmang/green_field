import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/campus.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';

class CampusOperatingSection extends StatelessWidget {
  const CampusOperatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            CampusExample().gwanack.operatingHours!.map((hour) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  hour,
                  style: AppTextsTheme.main().gfBody1.copyWith(
                    color: Theme.of(context).appColors.gfBlackColor,
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            children: [
              Image.asset(
                AppIcons.phone,
                width: 16,
                height: 16,
              ),
              SizedBox(width: 8),
              Text(
                CampusExample().gwanack.contactNumber,
                style: AppTextsTheme.main().gfCaption2Light.copyWith(
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
              ),
              SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero, // 패딩을 제로로 설정
                onPressed: () async {
                  // 전화 걸기 URL 생성
                  var url = Uri(scheme: 'tel', path: CampusExample().gwanack.contactNumber);

                  // 전화 앱이 열 수 있는지 확인
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url); // 전화 걸기
                  } else {
                    // 전화 앱을 열 수 없는 경우 처리
                    print('Could not launch $url');
                  }
                },
                child: Text(
                  "전화하기",
                  style: AppTextsTheme.main().gfCaption2.copyWith(
                    color: Theme.of(context).appColors.gfMainColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
