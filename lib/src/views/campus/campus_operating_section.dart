import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/campus.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/campus/campus_view_model.dart';

class CampusOperatingSection extends ConsumerStatefulWidget {
  const CampusOperatingSection({super.key});

  @override
  ConsumerState<CampusOperatingSection> createState() => _CampusOperatingSectionState();
}

class _CampusOperatingSectionState extends ConsumerState<CampusOperatingSection> {
  @override
  Widget build(BuildContext context) {
    final campusState = ref.watch(campusViewModelProvider);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (campusState.value?.operatingHours ?? []).map((hour) {
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
                campusState.value?.contactNumber ?? '',
                style: AppTextsTheme.main().gfCaption2Light.copyWith(
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
              ),
              SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero, // 패딩을 제로로 설정
                onPressed: () async {
                  // 전화 걸기 URL 생성
                  var url = Uri(scheme: 'tel', path: campusState.value?.contactNumber ?? '');

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

