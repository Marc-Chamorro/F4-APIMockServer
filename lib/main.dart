import 'package:flutter/material.dart';
import 'package:api_to_sqlite/src/pages/home_page.dart';
import 'package:api_to_sqlite/src/pages/welcome_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome',
      routes: {
        'home': (BuildContext context) => const HomePage(),
        'welcome': (BuildContext context) => WelcomePage(),
      },
    );
  }
}
