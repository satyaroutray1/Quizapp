import 'package:flutter/material.dart';
import 'view/pages/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Square',
      home: Splash(),
    );
  }
}