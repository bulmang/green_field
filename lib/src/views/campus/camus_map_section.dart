import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system/app_colors.dart';
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
        var encodedAddress = Uri.encodeComponent(CampusExample().gwanack.address);
        var url1 = 'nmap://place?lat=37.5665&lng=126.9780&name=서울시청';

        if (await canLaunchUrl(Uri.parse(url1))) {
          await launchUrl(Uri.parse(url1));
        } else {
          var web = 'https://map.naver.com/p/entry/place/1062623424?c=15.00,0,0,0,dh';
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
                'https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-11-21%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%204.47.19.png?alt=media&token=3bb33935-aceb-4cc8-b928-366762bef32d',
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
                CampusExample().gwanack.address,
                style: AppTextsTheme.main().gfCaption2Light.copyWith(
                  color: AppColorsTheme().gfBlackColor,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "검색하기",
                style: AppTextsTheme.main().gfCaption2.copyWith(
                  color: AppColorsTheme().gfMainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
