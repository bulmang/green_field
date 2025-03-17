import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:lottie/lottie.dart';

import '../../../utilities/design_system/app_colors.dart';
import '../../../utilities/design_system/app_texts.dart';

class MyChatBubbleWidget extends StatelessWidget {
  final String text;
  final DateTime time;

  const MyChatBubbleWidget({
    super.key,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          Text(
            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            style: AppTextsTheme.main().gfCaption5.copyWith(
              color: Theme.of(context).appColors.gfGray400Color,
            ),
          ),
          SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).appColors.gfBlackColor,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
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
        ],
      ),
    );
  }
}
