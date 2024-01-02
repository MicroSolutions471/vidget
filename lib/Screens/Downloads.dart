// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vidget/Screens/constant/colors.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  int selectedRadio = 0; // variable to keep track of selected radio button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor1,
        foregroundColor: Colors.white,
        title: const Text("Downloads"),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
