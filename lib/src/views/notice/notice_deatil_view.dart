import 'package:flutter/material.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../model/notice.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_content_widget.dart';
import '../../utilities/components/greenfield_user_info_widget.dart';

class NoticeDetailView extends StatefulWidget {
  final Notice notice;

  const NoticeDetailView({super.key, required this.notice});

  @override
  _NoticeDetailViewState createState() => _NoticeDetailViewState();
}

class _NoticeDetailViewState extends State<NoticeDetailView> {
  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "공지사항",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GreenfieldUserInfoWidget(
                featureType: FeatureType.notice,
                campus: notice.userCampus,
                createTimeText: '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
              ),
            ),
            GreenFieldContentWidget(
              title: notice.title,
              bodyText: notice.body,
              imageAssets: notice.images != null && notice.images!.isNotEmpty ? notice.images! : [],
              likes: notice.like.length,
              commentCount: 0,
            ),
          ],
        ),
      ),
    );
  }
}
