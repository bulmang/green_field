import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utilities/components/greenfield_tab_bar.dart';

class MainView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainView({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    /// noNavigationBarPaths 배열에 포함된 문자열이 있으면 bottomNavigationBar를 표시하지 않습니다.
    List<String> noNavigationBarPaths = ['detail', 'edit', 'setting'];

    bool _showNavigationBar = !noNavigationBarPaths.any((path) => navigationShell.shellRouteContext.routerState.fullPath!.contains(path));

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _showNavigationBar ? GreenFieldTabBar(
        navigationShell: navigationShell, // 현재 선택된 인덱스 전달
      ) : null,
    );
  }
}
