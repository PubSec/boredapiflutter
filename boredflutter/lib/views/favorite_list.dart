import 'package:flutter/material.dart';

class MyFavoriteListView extends StatefulWidget {
  const MyFavoriteListView({super.key});

  @override
  State<MyFavoriteListView> createState() => _MyFavoriteListViewState();
}

class _MyFavoriteListViewState extends State<MyFavoriteListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.home_filled),
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Favorite Activity',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text('No favorite activities'),
      ),
    );
  }
}
