import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_list.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/post_view_model.dart';
import '../../utilities/design_system/app_texts.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _selectedIndex = 0;
  final postVM = PostViewModel();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfBackGroundColor,
        title: "게시판",
        leadingIcon: SizedBox(),
        actions: [
          CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: Theme.of(context).appColors.gfGray400Color,
              ),
              onPressed: () {
                context.go('/post/edit');
              })
        ],
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: postVM.posts.length,
          itemBuilder: (context, index) {
            final post = postVM.posts[index];
            return GreenFieldList(
              title: post.title,
              content: post.body,
              date:
                  '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}',
              campus: post.creatorCampus,
              imageUrl: post.images != null && post.images!.isNotEmpty
                  ? post.images![0]
                  : "",
              likes: post.like.length,
              commentCount: post.comment.length,
              onTap: () {
                context.go('/post/detail/${post.id}');
              },
            );
          },
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 60,
          child: CupertinoButton(
            onPressed: () {
              context.go('/post/edit');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF308F5B), Color(0xFF666666)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.pencil,
                    color: Colors.white,
                  ),
                  SizedBox(width: 3), // Space between icon and text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0, right: 5),
                    child: Text(
                      '글 쓰기',
                      style: AppTextsTheme.main().gfCaption2.copyWith(
                            color: Theme.of(context).appColors.gfWhiteColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
