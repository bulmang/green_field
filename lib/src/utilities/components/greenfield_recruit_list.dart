import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/model/recruit.dart';

class GreenFieldRecruitList extends StatelessWidget {
  final Recruit recruits;
  final String userId;
  final VoidCallback onTap;

  const GreenFieldRecruitList({
    super.key,
    required this.recruits,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Column(
        children: [
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appColors.gfWhiteColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4), // 최대 너비 설정
                          child: Text(
                            recruits.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextsTheme.main().gfTitle1.copyWith(color: Theme.of(context).appColors.gfBlackColor),
                          ),
                        ),
                        Spacer(),
                        recruits.currentParticipants.contains(userId)
                            ? Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red, // 원의 색상
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              '참여중',
                              style: AppTextsTheme.main()
                                  .gfCaption5
                                  .copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      recruits.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextsTheme.main().gfBody2.copyWith(
                            color: Theme.of(context).appColors.gfBlackColor,
                          ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).appColors.gfGray800Color, // 테두리 색상
                              width: 1, // 테두리 두께
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppIcons.tagIcon,
                                  width: 9,
                                  height: 9,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${recruits.creatorCampus}캠퍼스',
                                  style: AppTextsTheme.main()
                                      .gfCaption5
                                      .copyWith(
                                        color: Theme.of(context).appColors.gfGray800Color,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        recruits.currentParticipants.contains(userId)
                            ? SizedBox.shrink()
                            : Container(
                          decoration: BoxDecoration(
                            color: recruits.currentParticipants.length != recruits.maxParticipants
                                ? Theme.of(context).appColors.gfMainBackGroundColor
                                : Theme.of(context).appColors.gfWarningBackGroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  recruits.currentParticipants.length != recruits.maxParticipants
                                      ? AppIcons.checkCircle
                                      : AppIcons.xCircle,
                                  width: 9,
                                  height: 9,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  recruits.currentParticipants.length != recruits.maxParticipants
                                      ? "채팅입장 가능"
                                      :  "입장 불가능",
                                  style: AppTextsTheme.main()
                                      .gfCaption5
                                      .copyWith(
                                        color: recruits.currentParticipants.length != recruits.maxParticipants
                                            ? Theme.of(context).appColors.gfMainColor
                                            : Theme.of(context).appColors.gfWarningColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        if (DateTime.now().difference(recruits.remainTime).inMinutes.abs() <= 30)
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).appColors
                                  .gfWarningYellowBackGroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppIcons.alertCircle,
                                    width: 9,
                                    height: 9,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "곧 사라져요!",
                                    style: AppTextsTheme.main()
                                        .gfCaption5
                                        .copyWith(
                                          color: Theme.of(context).appColors
                                              .gfWarningYellowColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AppIcons.clockGreen,
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 3),
                            Text(
                              '${DateTime.now().difference(recruits.remainTime).inMinutes.abs()} min',
                              style: AppTextsTheme.main().gfCaption2Light.copyWith(
                                    color: Theme.of(context).appColors.gfMainColor,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AppIcons.userGreen,
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 1),
                            Text(
                              '${recruits.currentParticipants.length.toString()} / ${recruits.maxParticipants.toString()}',
                              style: AppTextsTheme.main().gfCaption2Light.copyWith(
                                    color: Theme.of(context).appColors.gfMainColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
