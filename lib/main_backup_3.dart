// // ignore_for_file: dead_code, avoid_print

// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// void main() {
//   runApp(const MaterialApp(home: WebViewScreen()));
// }

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({super.key});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   @override
//   void initState() {
//     super.initState();
//     loadVideo(index: 0);
//   }

//   String htmlData = '';
//   String origionalHtmlData = '';

//   InAppWebViewController? webViewController;

//   final List<String> videos = [
//     "29d0d68f-bc31-4c9b-bd6a-bcbc0c526382",
//     "f0b2c6bc-38c9-4049-8c7b-a09708f95d6c",
//     "29d0d68f-bc31-4c9b-bd6a-bcbc0c526382",
//     "f0b2c6bc-38c9-4049-8c7b-a09708f95d6c",
//     "64601abb-7fdc-4bf7-9cdd-fcdf4069ae7b",
//     "93879e07-badc-46c0-88eb-3622c963cae6",
//     "328b752b-c488-47b0-8203-ba002d20be63",
//     "759c85af-c027-4622-820a-54d9fb8a7a95",
//     "a3a483c0-5e5a-403a-ac45-140eb88bb869",
//     "867d1bf9-0968-4fed-9d24-f1979fcf19e4",
//     "64ed8c7c-daf3-4d15-ad7f-2095fa4efabb",
//     "673d7730-a277-45fa-8fff-ea1369765859",
//     "d789d391-054c-42dd-a4c9-6e7065e5bb65",
//     "01c8daad-3017-4d5c-8496-557e12c29034",
//   ];

//   final List<String> loadedVideos = [];

//   // String getRandomVideoID() {
//   //   if (loadedVideos.length == videos.length) {
//   //     loadedVideos.clear();
//   //     loadedVideos.add(videos[0]);
//   //   } else {
//   //     loadedVideos.add(videos[loadedVideos.length]);
//   //   }
//   //   return loadedVideos.last;
//   // }
//   // loadData() async {
//   //   String htmlFileData = await rootBundle.loadString('assets/index.html');
//   //   htmlData = htmlFileData;
//   //   String videoId = getRandomVideoID();
//   //   print("Loading Video : $videoId");
//   //   await webViewController?.loadData(
//   //     data: htmlData.replaceAll('{{videoid}}', videoId),
//   //      .replaceFirst('<<playerVars>>', params.toJson())
//   //      .replaceFirst('<<platform>>', platform)
//   //      .replaceFirst('<<host>>', params.origin ?? 'https://www.youtube.com'),
//   //   );
//   // }

//   int currentIndex = 0;
//   Future<void> loadVideo({required int index}) async {
//     print("index" + index.toString());

//     if (htmlData.trim().isEmpty || origionalHtmlData.toString().trim().isEmpty) {
//       String htmlFileData = await rootBundle.loadString('assets/index.html');
//       htmlData = htmlFileData;
//       origionalHtmlData = htmlFileData;
//     }

//     if (index < 0 || (index >= videos.length)) return;

//     currentIndex = index;

//     String videoId = videos[index];

//     print("videoId : " + videoId.toString());

//     if (webViewController == null) {
//       htmlData = htmlData.replaceAll('{{videoid}}', videoId);
//       setState(() {});
//       return;
//     }

//     print("Loading Video : $videoId");

//     htmlData = origionalHtmlData.replaceAll('{{videoid}}', videoId);

//     await webViewController?.loadData(
//       data: origionalHtmlData.replaceAll('{{videoid}}', videoId),
//     );
//   }

//   String get userAgent =>
//       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             htmlData.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : IgnorePointer(
//                     ignoring: true,
//                     child: InAppWebView(
//                       // initialFile: "assets/index.html",
//                       initialData: InAppWebViewInitialData(
//                         data: htmlData,
//                         encoding: 'utf-8',
//                         mimeType: 'text/html',
//                       ),
//                       initialSettings: InAppWebViewSettings(
//                         userAgent: userAgent,
//                         mediaPlaybackRequiresUserGesture: false,
//                         transparentBackground: true,
//                         disableContextMenu: true,
//                         supportZoom: false,
//                         disableHorizontalScroll: true,
//                         disableVerticalScroll: true,
//                         iframeAllowFullscreen: false,
//                         isElementFullscreenEnabled: false,
//                         allowsInlineMediaPlayback: true,
//                         allowsAirPlayForMediaPlayback: true,
//                         allowsPictureInPictureMediaPlayback: true,
//                         useWideViewPort: false,
//                       ),
//                       gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
//                         Factory<OneSequenceGestureRecognizer>(
//                           () => TapGestureRecognizer()..onTap = _handleTap,
//                         ),
//                       },
//                       onLoadStart: (controller, url) {},
//                       onLoadStop: (controller, url) async {
//                         // if (webViewController == null) return;
//                         // var data = await webViewController!
//                         //     .evaluateJavascript(source: "document.getElementById('loader').style.display = 'none';");
//                         // if (data != null) {
//                         //   print("Evalution : $data");
//                         // }
//                       },
//                       onWebViewCreated: (webController) {
//                         // webController.addJavaScriptHandler(
//                         //   handlerName: 'disableDoubleTapZoom',
//                         //   callback: (args) {
//                         //     return true;
//                         //   },
//                         // );
//                         webViewController = webController;
//                         // webController
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "play",
//                         //     callback: (arguments) {
//                         //       print("============play");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "pause",
//                         //     callback: (arguments) {
//                         //       print("============pause");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "activate",
//                         //     callback: (arguments) {
//                         //       print("============activate");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "ended",
//                         //     callback: (arguments) {
//                         //       print("============ended");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "error",
//                         //     callback: (arguments) {
//                         //       print("============error :- $arguments");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "enterfullscreen",
//                         //     callback: (arguments) {
//                         //       print("============enterfullscreen");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "exitfullscreen",
//                         //     callback: (arguments) {
//                         //       print("============exitfullscreen");
//                         //     },
//                         //   )
//                         //   ..addJavaScriptHandler(
//                         //     handlerName: "enterfullscreen",
//                         //     callback: (arguments) {
//                         //       print("============enterfullscreen");
//                         //     },
//                         //   );
//                       },
//                       onConsoleMessage: (controller, consoleMessage) {
//                         print("Evalution : ${consoleMessage.message}");
//                       },
//                     ),
//                   ),
//             GestureDetector(
//               onPanEnd: (details) {
//                 if (details.velocity.pixelsPerSecond.dy > 600) {
//                   loadVideo(index: currentIndex - 1);
//                   print("Load Previous");
//                   // animCubit.playPreviousVideo();
//                 } else if (details.velocity.pixelsPerSecond.dy < -600) {
//                   loadVideo(index: currentIndex + 1);
//                   print("Load Next");
//                 }
//               },
//               onTap: () async => await _handleTap(),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 color: Colors.transparent,
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // FloatingActionButton(
//           //   onPressed: () async {
//           //     if (webViewController == null) return;
//           //     var data = await webViewController!
//           //         .evaluateJavascript(source: 'flutterControl({ "command": "pause", "parameter": null });');
//           //     if (data != null) {
//           //       print("Evalution : $data");
//           //     }
//           //   },
//           //   child: Icon(Icons.pause),
//           // ),
//           // SizedBox(width: 8),
//           // FloatingActionButton(
//           //   onPressed: () async {
//           //     if (webViewController == null) return;
//           //     var data = await webViewController!
//           //         .evaluateJavascript(source: 'flutterControl({ "command": "play", "parameter": null });');
//           //     if (data != null) {
//           //       print("Evalution : $data");
//           //     }
//           //   },
//           //   child: Icon(Icons.play_arrow),
//           // ),
//           // SizedBox(width: 8),
//           SizedBox(
//             width: 100,
//             child: FloatingActionButton(
//               onPressed: () async {
//                 if (webViewController == null) return;
//                 var data = await webViewController!
//                     .evaluateJavascript(source: 'flutterControl({ "command": "togglePlay", "parameter": null });');
//                 if (data != null) {
//                   print("Evalution : $data");
//                 }
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(Icons.play_arrow),
//                   Text("/", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 26)),
//                   Icon(Icons.pause),
//                 ],
//               ),
//             ),
//           ),
//           // SizedBox(width: 8),
//           // FloatingActionButton(
//           //   onPressed: () async => await loadData(),
//           //   child: Icon(Icons.replay_outlined),
//           // ),
//         ],
//       ),
//     );
//   }

//   Future<void> _handleTap() async {
//     if (webViewController == null) return;
//     var data = await webViewController!
//         .evaluateJavascript(source: 'flutterControl({ "command": "togglePlay", "parameter": null });');
//     if (data != null) {
//       print("Evalution : $data");
//     }
//   }
// }
