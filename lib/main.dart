import 'package:flutter/material.dart';

import 'map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map And Live tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Mappage(),
    );
  }
}

