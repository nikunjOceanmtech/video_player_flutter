import 'package:flutter/material.dart';
import 'package:video_player_flutter/global.dart';
import 'package:video_player_flutter/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearCache();
  runApp(const MaterialApp(home: HomeScreen()));
}
