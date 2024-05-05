import 'package:flutter/material.dart';
import 'package:products_newest/list_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListPageWidget(Key('1')),
    );
  }
}
