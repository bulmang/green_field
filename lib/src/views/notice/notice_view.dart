import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
import 'package:green_field/src/design_system/app_colors.dart';

import '../../viewmodels/notice_view_model.dart';

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  _NoticeViewState createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  final noticeVM = NoticeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme().gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfWhiteColor,
        title: "공지사항",
      ),
      body: ListView.builder(
        itemCount: noticeVM.notices.length,
        itemBuilder: (context, index) {
          final notice = noticeVM.notices[index];
          return GreenFieldList(
            title: notice.title,
            content: notice.body,
            date: '${notice.createdAt.year}-${notice.createdAt.month}-${notice.createdAt.day}',
            campus: notice.userCampus,
            imageUrl: notice.images != null && notice.images!.isNotEmpty ? notice.images![0] : "",
            likes: notice.like.length,
            commentCount: 0,
            onTap: () {
              context.go('/noticedetail/${notice.id}');
            },
          );
        },
      ),
    );
  }
}
