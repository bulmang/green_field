import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../../utilities/design_system/app_icons.dart';
import '../../../utilities/design_system/app_texts.dart';

class OtherChatBubbleWidget extends StatelessWidget {
  final String text;
  final DateTime time;
  final String creatorName;
  final bool isPreviousSameUser;

  const OtherChatBubbleWidget({
    super.key,
    required this.text,
    required this.time,
    required this.creatorName,
    required this.isPreviousSameUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 7.0, bottom: isPreviousSameUser ? 7 : 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isPreviousSameUser
              ? SizedBox(width: 32)
              : Image.asset(AppIcons.profile, width: 32, height: 32),
          SizedBox(width: 4),
          isPreviousSameUser
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).appColors.gfMainColor,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: AppTextsTheme.main().gfBody5.copyWith(
                        color: Theme.of(context).appColors.gfBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                style: AppTextsTheme.main().gfCaption5.copyWith(
                  color: Theme.of(context).appColors.gfGray400Color,
                ),
              ),
            ],
          )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creatorName,
                      style: AppTextsTheme.main().gfBody5.copyWith(
                          color: Theme.of(context).appColors.gfMainColor
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).appColors.gfMainColor,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                text,
                                style: AppTextsTheme.main().gfBody5.copyWith(
                                  color: Theme.of(context).appColors.gfBlackColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                          style: AppTextsTheme.main().gfCaption5.copyWith(
                            color: Theme.of(context).appColors.gfGray400Color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          Spacer(),
        ],
      ),
    );
  }
}
