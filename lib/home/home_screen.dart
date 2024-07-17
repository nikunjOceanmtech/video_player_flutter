import 'package:flutter/material.dart';
import 'package:video_player_flutter/home/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends HomeWidget {
  @override
  Widget build(BuildContext context) {
    print("Controllers Length : ${controllers.length}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: screenView(context: context),
      floatingActionButton: floatingButton(context: context),
    );
  }
}
