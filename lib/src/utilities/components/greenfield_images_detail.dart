import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/router/router.dart';
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
  const DetailScreenPageView({
    super.key,
    required this.widgets,
    required this.initialIndex,
  });

  final List<Widget> widgets;
  final int initialIndex;

  @override
  State<DetailScreenPageView> createState() => _DetailScreenPageView();
}

class _DetailScreenPageView extends State<DetailScreenPageView>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  final TransformationController _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: widget.initialIndex);

    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: widget.widgets.length,
      vsync: this,
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
      _transformationController.value = _animation!.value;
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _doubleTapZoom() {
    final position = _doubleTapDetails.localPosition;
    final endMatrix = _transformationController.value.isIdentity()
        ? (Matrix4.identity()
      ..translate(-position.dx, -position.dy)
      ..scale(2.0))
        : Matrix4.identity();

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          itemCount: widget.widgets.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => context.pop(),
              onDoubleTapDown: (d) => _doubleTapDetails = d,
              onDoubleTap: _doubleTapZoom,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                child: widget.widgets[index],
              ),
            );
          },
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
