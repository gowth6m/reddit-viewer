import 'package:flutter/material.dart';

import 'ui/home.dart';

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
        primaryColor: const Color.fromARGB(255, 255, 86, 0),
      ),
      home: const HomePage(),
    );
  }
}
