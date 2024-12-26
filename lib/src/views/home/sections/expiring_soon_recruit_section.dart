import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/recruit_view_model.dart';
import '../../../design_system/app_texts.dart';

class ExpiringSoonRecruitSection extends StatelessWidget {

  const ExpiringSoonRecruitSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recruitVM = RecruitViewModel();

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recruitVM.recruits.length,
          itemBuilder: (context, index) {
            final recruit = recruitVM.recruits[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: BoxDecoration(
                  color: Theme.of(context).appColors.gfMainColor.withOpacity(0.6 - (index * 0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.go('/recruit/detail/${recruit.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recruit.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextsTheme.main().gfTitle2.copyWith(
                            color: Theme.of(context).appColors.gfWhiteColor,
                          ),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              recruit.body,
                              style: AppTextsTheme.main().gfCaption2.copyWith(
                                color: Theme.of(context).appColors.gfWhiteColor,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '참여하기',
                                  style: AppTextsTheme.main().gfCaption2.copyWith(
                                    color: Theme.of(context).appColors.gfWhiteColor,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  size:12,
                                  color: Theme.of(context).appColors.gfWhiteColor,
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  AppIcons.clock,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${recruit.remainTime.toString()} min',
                                  style: AppTextsTheme.main().gfCaption2.copyWith(
                                    color: Theme.of(context).appColors.gfWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  AppIcons.user,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  '${recruit.currentParticipants.length.toString()} / ${recruit.maxParticipants.toString()}',
                                  style: AppTextsTheme.main().gfCaption2.copyWith(
                                    color: Theme.of(context).appColors.gfWhiteColor,
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
            );
          },
        ),
      ),
    );
  }
}
