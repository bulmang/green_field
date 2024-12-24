import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_confirm_button.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_user_info_widget.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/extensions/theme_data_extension.dart';

import '../../model/recruit.dart'; // Assuming you have a Recruit model

class RecruitDetailView extends StatefulWidget {
  final Recruit recruit; // Recruit object to display details

  const RecruitDetailView({super.key, required this.recruit});

  @override
  _RecruitDetailViewState createState() => _RecruitDetailViewState();
}

class _RecruitDetailViewState extends State<RecruitDetailView> {
  @override
  Widget build(BuildContext context) {
    final recruit = widget.recruit;

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "모집",
        leadingIcon: Icon(
          CupertinoIcons.xmark,
          color: Theme.of(context).appColors.gfGray400Color,
        ),
        leadingAction: (){
          context.pop();
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: GreenfieldUserInfoWidget(
                        featureType: FeatureType.recruit,
                        campus: recruit.creatorCampus,
                        createTimeText: '${recruit.createdAt.year}-${recruit.createdAt.month}-${recruit.createdAt.day}',
                      ),
                    ),
                    GreenFieldContentWidget(
                      featureType: FeatureType.recruit,
                      title: recruit.title,
                      bodyText: recruit.body,
                      imageAssets: recruit.images != null && recruit.images!.isNotEmpty ? recruit.images! : [],
                      recruit: recruit,
                      commentCount: 0,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: GreenFieldConfirmButton(
                text: recruit.isEntryAvailable ? "채팅으로 이야기 해보기" : "채팅방 입장 불가",
                isAble: recruit.isEntryAvailable,
                textColor: recruit.isEntryAvailable ? Theme.of(context).appColors.gfMainColor : Theme.of(context).appColors.gfWarningColor,
                backGroundColor: recruit.isEntryAvailable ? Theme.of(context).appColors.gfMainBackGroundColor : Theme.of(context).appColors.gfWarningBackGroundColor,
                onPressed: () {
                  print("눌림");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
