// ignore_for_file: cast_from_null_always_fails, unnecessary_null_comparison, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:vidget/Screens/Dashboard.dart';
import 'package:vidget/Screens/constant/colors.dart';

//youtube api key
//AIzaSyAPcOGxPuV4CX_5lfzdKhozPoyorpZ7IT8
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VidGet',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              backgroundColor: primaryColor3, foregroundColor: Colors.white),
          scaffoldBackgroundColor: Colors.white),
      home: const Dashboard(),
    );
  }
}
