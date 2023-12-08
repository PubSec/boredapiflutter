import 'package:boredflutter/views/favorite_list.dart';
import 'package:boredflutter/views/home_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Are You Bored?',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const MyHomePage(),
        "favorite": (context) => const MyFavoriteListView(),
      },
    );
  }
}
