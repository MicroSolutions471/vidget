// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vidget/Screens/Downloads.dart';
import 'package:vidget/Screens/Home.dart';
import 'package:vidget/Screens/Search.dart';
import 'package:vidget/Screens/constant/colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController _pageController = PageController();
  List<Widget> pages = [const Home(), const Downloads()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VidGet"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(EvaIcons.searchOutline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _pageController,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor3,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.home),
            label: 'Home',
          ),
          // Add more items if needed
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.download),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }
}
