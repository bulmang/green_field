import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/design_system/app_icons.dart';
import 'package:green_field/src/utilities/design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

class GreenFieldExpiringSoonList extends ConsumerWidget {
  final String title;
  final String body;
  final String remainTime;
  final String currentParticipants;
  final String maxParticipants;
  final bool? isDummyData;
  final Function() onPressedCallback;

  const GreenFieldExpiringSoonList({
    super.key,
    required this.title,
    required this.body,
    required this.remainTime,
    required this.currentParticipants,
    required this.maxParticipants,
    this.isDummyData,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: MediaQuery.of(context).size.width / 1.3,
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.gfMainColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressedCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                      body,
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
                          (isDummyData != null) ? '작성하러가기'  : '참여하기',
                          style: AppTextsTheme.main().gfCaption2.copyWith(
                            color: Theme.of(context).appColors.gfWhiteColor,
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 12,
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
                          '$remainTime min',
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
                          '$currentParticipants / $maxParticipants',
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
  }
}

