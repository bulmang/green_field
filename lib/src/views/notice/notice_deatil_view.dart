import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_user_info_widget.dart';
import 'package:green_field/src/design_system/app_colors.dart';

import '../../model/notice.dart';

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
      backgroundColor: AppColorsTheme().gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfWhiteColor,
        title: "공지사항",
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: Colors.grey), // Cupertino 아이콘 사용
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GreenfieldUserInfoWidget(
              type: 'notice',
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
    );
  }
}
