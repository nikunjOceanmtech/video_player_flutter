// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:video_streming/hls_tracks_page.dart';
// import 'package:video_streming/raw_youtube.dart';
// import 'package:video_streming/webview.dart';
// import 'package:video_streming/webview_old.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: 1 == 1 ? WebViewPlayer() : HlsTracksPage()
//         //  : const MyHomePage(title: 'Flutter Demo Home Page'),
//         );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     playVideo(url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
//   }

//   void playVideo({required String url}) {
//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(url),
//       formatHint: VideoFormat.hls,
//     )..initialize().then(
//         (_) {
//           setState(() {
//             _controller!.play();
//           });
//         },
//       );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: _controller != null && _controller!.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: VideoPlayer(_controller!),
//               )
//             : Container(),
//       ),
//       floatingActionButton: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   playVideo(
//                     url: "https://vz-352e339f-24b.b-cdn.net/be21ea4d-ecea-4239-a1fc-bd1f9f58651b/playlist.m3u8",
//                   );
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   color: Colors.green,
//                   child: const Icon(Icons.fiber_new, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 4),
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   if (_controller == null) return;
//                   _controller!
//                     ..seekTo(Duration.zero)
//                     ..play();
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   color: Colors.green,
//                   child: const Icon(Icons.replay_outlined, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 4),
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   if (_controller == null) return;
//                   setState(() {
//                     _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
//                   });
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   color: Colors.green,
//                   child: Icon(
//                     _controller != null && _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
