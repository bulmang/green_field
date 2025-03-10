import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/cores/error_handler/result.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/campus/campus_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../model/campus.dart';

class CampusMapSection extends ConsumerStatefulWidget {
  const CampusMapSection({super.key});

  @override
  ConsumerState<CampusMapSection> createState() => _CampusMapSectionState();
}

class _CampusMapSectionState extends ConsumerState<CampusMapSection> {
  @override
  Widget build(BuildContext context) {
    final campusState = ref.watch(campusViewModelProvider);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        // final result = await ref.read(campusViewModelProvider.notifier).createCampus();
        //
        // switch (result) {
        //   case Success(value: final v):
        //     print('v: $v');
        //   case Failure(exception: final e):
        //     print(e.toString());
        // }
        var encodedAddress = Uri.encodeComponent(campusState.value!.address['NaverMapURLScheme']);
        var url = 'nmap://search?query=$encodedAddress';

        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          var web = campusState.value!.address['NaverWebURL'];
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
              child: CachedNetworkImage(
                imageUrl: campusState.value!.address['MapImageURL'],
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
                campusState.value!.address['CampusAddress']!,
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

