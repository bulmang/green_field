import 'package:flutter/cupertino.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/design_system/app_texts.dart';
import 'package:green_field/src/model/recruit.dart';
import '../design_system/app_colors.dart';

class GreenFieldRecruitList extends StatelessWidget {
  final Recruit recruits;
  final VoidCallback onTap;

  const GreenFieldRecruitList({
    super.key,
    required this.recruits,
    required this.onTap
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
                color: AppColorsTheme().gfWhiteColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recruits.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextsTheme.main().gfTitle1.copyWith(
                            color: AppColorsTheme().gfBlackColor,
                          ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      recruits.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextsTheme.main().gfBody2.copyWith(
                            color: AppColorsTheme().gfBlackColor,
                          ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColorsTheme().gfGray800Color, // 테두리 색상
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
                                  recruits.creatorCampus,
                                  style: AppTextsTheme.main()
                                      .gfCaption5
                                      .copyWith(
                                        color: AppColorsTheme().gfGray800Color,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: recruits.isEntryAvailable
                                ? AppColorsTheme().gfMainBackGroundColor
                                : AppColorsTheme().gfWarningBackGroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  recruits.isEntryAvailable
                                      ? AppIcons.checkCircle
                                      : AppIcons.xCircle,
                                  width: 9,
                                  height: 9,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  recruits.isEntryAvailable
                                      ? "채팅입장 가능"
                                      : "입장 불가능",
                                  style: AppTextsTheme.main()
                                      .gfCaption5
                                      .copyWith(
                                        color: recruits.isEntryAvailable
                                            ? AppColorsTheme().gfMainColor
                                            : AppColorsTheme().gfWarningColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        if (recruits.isTimeExpired)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColorsTheme()
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
                                          color: AppColorsTheme()
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
                              '${recruits.remainTime.toString()} min',
                              style: AppTextsTheme.main().gfCaption2Light.copyWith(
                                    color: AppColorsTheme().gfMainColor,
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
                                    color: AppColorsTheme().gfMainColor,
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
