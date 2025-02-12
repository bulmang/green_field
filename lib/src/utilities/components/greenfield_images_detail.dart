import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/components/greenfield_app_bar.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

import '../../cores/image_type/image_type.dart';

class GreenFieldImagesDetail extends StatelessWidget {
  const GreenFieldImagesDetail({
    super.key,
    required this.tags,
    required this.initialIndex,
  });
  final List<String?> tags;
  final int initialIndex;
  @override
  Widget build(BuildContext context) {
    final heroWidgets = tags
        .map((path) => Hero(
        tag: path!,
        child: CachedNetworkImage(
          imageUrl: path.toString(),
        ),
      ),
    )
        .toList();

    return Scaffold(
      appBar: GreenFieldAppBar(backgGroundColor: Theme.of(context).appColors.gfWhiteColor, title: ''),
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      body: SafeArea(
        child: DetailScreenPageView(
          widgets: heroWidgets,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class DetailScreenPageView extends StatefulWidget {
  const DetailScreenPageView(
      {super.key, required this.widgets, required this.initialIndex});
  final List<Widget> widgets;
  final int initialIndex;
  @override
  State<DetailScreenPageView> createState() => _DetailScreenPageView();
}

class _DetailScreenPageView extends State<DetailScreenPageView>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: widget.initialIndex);

    _tabController = TabController(
        initialIndex: widget.initialIndex,
        length: widget.widgets.length,
        vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: widget.widgets,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: PageIndicator(
            tabController: _tabController,
          ),
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            controller: tabController,
            color: Theme.of(context).appColors.gfBackGroundColor,
            selectedColor: Theme.of(context).appColors.gfMainColor,
          ),
        ],
      ),
    );
  }
}
