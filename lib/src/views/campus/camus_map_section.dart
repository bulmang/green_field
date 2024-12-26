import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system/app_icons.dart';
import '../../design_system/app_texts.dart';
import '../../model/campus.dart';

class CampusMapSection extends StatelessWidget {
  const CampusMapSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // 주소를 URL 인코딩
        var encodedAddress = Uri.encodeComponent(CampusExample().gwanack.address['NaverMapURLScheme']!);
        var url = 'nmap://search?query=$encodedAddress';

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          var web = CampusExample().gwanack.address['NaverWebURL']!;
          await launchUrl(Uri.parse(web));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                CampusExample().gwanack.address['MapImageURL']!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(
                AppIcons.mapPin,
                width: 16,
                height: 16,
              ),
              SizedBox(width: 8),
              Text(
                CampusExample().gwanack.address['CampusAddress']!,
                style: AppTextsTheme.main().gfCaption2Light.copyWith(
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "검색하기",
                style: AppTextsTheme.main().gfCaption2.copyWith(
                  color: Theme.of(context).appColors.gfMainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
