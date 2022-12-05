import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reddit_viewer/ui/home_page.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('Testing for initial widget in HomePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.textContaining('Search for a subreddit'), findsWidgets);
      expect(find.textContaining('Example: FlutterDev'), findsWidgets);
    });
  });
}
