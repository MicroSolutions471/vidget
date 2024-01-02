// ignore_for_file: cast_from_null_always_fails, unnecessary_null_comparison, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:vidget/Screens/Dashboard.dart';

//youtube api key
//AIzaSyAPcOGxPuV4CX_5lfzdKhozPoyorpZ7IT8
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          primarySwatch: Colors.orange,
          useMaterial3: true,
          appBarTheme: AppBarTheme(backgroundColor: Colors.orange.shade800),
          scaffoldBackgroundColor: Colors.white),
      home: const Dashboard(),
    );
  }
}
