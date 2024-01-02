// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vidget/Screens/Downloads.dart';
import 'package:vidget/Screens/Home.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            primaryColor1,
            primaryColor2,
          ])),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "VidGet",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            // Ensure that this callback is triggered when you swipe between pages.
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
        selectedItemColor: primaryColor1,
        currentIndex: _currentIndex,
        onTap: (index) {
          // Ensure that this callback is triggered when you tap on different items.
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
