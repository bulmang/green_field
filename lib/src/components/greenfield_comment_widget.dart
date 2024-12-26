import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../utilities/design_system/app_icons.dart';
import '../utilities/design_system/app_texts.dart';

class GreenFieldCommentWidget extends StatelessWidget {
  final String campus;
  final DateTime dateTime;
  final String comment;

  const GreenFieldCommentWidget({
    super.key,
    required this.campus,
    required this.dateTime,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: Theme.of(context).appColors.gfGray300Color,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(left: 30, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppIcons.profile, width: 30, height: 30),
                  SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campus,
                          style: AppTextsTheme.main().gfBody5.copyWith(
                            color: Theme.of(context).appColors.gfBlackColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                          style: AppTextsTheme.main().gfCaption5.copyWith(
                            color: Theme.of(context).appColors.gfGray400Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                  comment.length > 300 ? '${comment.substring(0, 300)}...' : comment,
                  style: AppTextsTheme.main().gfBody5.copyWith(
                    color: Theme.of(context).appColors.gfBlackColor,
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }
}
