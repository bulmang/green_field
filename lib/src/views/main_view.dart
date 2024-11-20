import 'package:flutter/material.dart';
import 'package:green_field/src/views/recruitment/picker/recruit_picker_modal.dart';
import 'package:green_field/src/views/recruitment/recruitment_view.dart';
import '../components/greenfield_tab_bar.dart';
import 'board/board_view.dart';
import 'home/home_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    HomeView(),
    RecruitView(),
    BoardView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_selectedIndex], // Display the selected view
      bottomNavigationBar: GreenFieldTabBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
