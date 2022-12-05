import 'package:flutter/material.dart';
import 'package:reddit_viewer/misc/design.dart';
import 'package:reddit_viewer/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reddit Viewer',
      theme: ThemeData(
        primaryColor: DesignColors.redditOrange,
      ),
      home: const HomePage(),
    );
  }
}
