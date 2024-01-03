// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vidget/Screens/WebViewScreen.dart';
import 'package:vidget/utilities/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "Top Sites",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: double.maxFinite,
              child: GridView.count(
                crossAxisCount: 5,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WebViewScreen(
                              appbarColor: Colors.red.shade700,
                              title: "YouTube",
                              url: "https://www.youtube.com/",
                            ),
                            transitionDuration: const Duration(seconds: 0),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child;
                            },
                          ),
                        );
                      },
                      child: homeTab(
                          'assets/icons/youtube.png', "Youtube", 30, 30, 12)),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WebViewScreen(
                              appbarColor: Colors.blue.shade900,
                              title: "Facebook",
                              url: "https://web.facebook.com/",
                            ),
                            transitionDuration: const Duration(seconds: 0),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child;
                            },
                          ),
                        );
                      },
                      child: homeTab(
                          'assets/icons/facebook.png', "Facebook", 30, 30, 12)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  WebViewScreen(
                            appbarColor: Colors.orange.shade800,
                            title: "Instagram",
                            url: "https://www.instagram.com/",
                          ),
                          transitionDuration: const Duration(seconds: 0),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          },
                        ),
                      );
                    },
                    child: homeTab(
                        'assets/icons/instagram.png', "Instagram", 30, 30, 12),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WebViewScreen(
                              appbarColor: Colors.lightBlueAccent,
                              title: "Vimeo",
                              url: "https://vimeo.com/",
                            ),
                            transitionDuration: const Duration(seconds: 0),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return child;
                            },
                          ),
                        );
                      },
                      child: homeTab(
                          'assets/icons/vimeo.png', "Vimeo", 30, 30, 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
