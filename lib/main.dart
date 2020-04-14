import 'package:flutter/material.dart';

import './SelectLanguage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museum',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
      ),
      home: SelectLanguagePage(),
    );
  }
}
