import 'package:flutter/material.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_comment_widget.dart';
import 'package:green_field/src/components/greenfield_content_widget.dart';
import 'package:green_field/src/components/greenfield_text_field.dart';
import 'package:green_field/src/components/greenfield_user_info_widget.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/model/post.dart';

class PostDetailView extends StatefulWidget {
  final Post post; // Assuming BoardPost is your model

  const PostDetailView({super.key, required this.post});

  @override
  _PostDetailViewState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: _getLimitedTitle(post.title, 20),
      ),
      body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: GreenfieldUserInfoWidget(
                        featureType: FeatureType.post,
                        campus: post.creatorCampus,
                        createTimeText:
                            '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}',
                      ),
                    ),
                    GreenFieldContentWidget(
                      title: post.title,
                      bodyText: post.body,
                      imageAssets: post.images != null && post.images!.isNotEmpty
                          ? post.images!
                          : [],
                      likes: post.like.length,
                      commentCount: post.comment?.length ??
                          0, // Assuming you have comments in your model
                    ),
                    ...post.comment!.map((comment) {
                      // Assuming each comment has properties like campus, dateTime, and content
                      return GreenFieldCommentWidget(
                        campus: comment
                            .creatorCampus, // Assuming comment has a campus property
                        dateTime: comment
                            .createdAt, // Assuming comment has a dateTime property
                        comment: comment
                            .body, // Assuming comment has a content property
                      );
                    }),
                  ],
                ),
              ),
            ),
            GreenFieldTextField(
              type: FeatureType.post,
              onAction: (String text) {
                // TODO: Implement onAction
              },
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar에 들어갈 제목의 글자 수를 제한하는 함수
  String _getLimitedTitle(String title, int maxLength) {
    if (title.length > maxLength) {
      return '${title.substring(0, maxLength)}...';
    }
    return title;
  }
}
