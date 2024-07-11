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

//   final PageController _pageController = PageController();
//   List<InAppWebViewController?> webViewControllers = [null, null, null];

//   int currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadVideo(0, null);
//     _pageController.addListener(_handleScroll);
//   }

//   void _handleScroll() {
//     int newIndex = _pageController.page!.round();
//     if (newIndex != currentIndex) {
//       setState(() {
//         currentIndex = newIndex;
//         loadVideos();
//       });
//     }
//   }

//   Future<void> loadVideos() async {
//     if (currentIndex > 0) {
//       await loadVideo(currentIndex - 1, webViewControllers[0]);
//     }
//     await loadVideo(currentIndex, webViewControllers[1]);
//     if (currentIndex < videos.length - 1) {
//       await loadVideo(currentIndex + 1, webViewControllers[2]);
//     }
//   }

//   Future<void> loadVideo(int index, InAppWebViewController? controller) async {
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

//     if (controller == null) {
//       htmlData = htmlData.replaceAll('{{videoid}}', videoId);
//       setState(() {});
//       return;
//     }

//     print("Loading Video : $videoId");

//     htmlData = origionalHtmlData.replaceAll('{{videoid}}', videoId);

//     await controller.loadData(
//       data: origionalHtmlData.replaceAll('{{videoid}}', videoId),
//     );
//   }

//   String htmlData = '';
//   String origionalHtmlData = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WebView Reels'),
//       ),
//       body: PageView.builder(
//         controller: _pageController,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           return InAppWebView(
//             // initialFile: "assets/index.html",
//             initialData: InAppWebViewInitialData(
//               data: htmlData,
//               encoding: 'utf-8',
//               mimeType: 'text/html',
//             ),
//             onWebViewCreated: (controller) {
//               if (index == currentIndex - 1) {
//                 webViewControllers[0] = controller;
//               } else if (index == currentIndex) {
//                 webViewControllers[1] = controller;
//               } else if (index == currentIndex + 1) {
//                 webViewControllers[2] = controller;
//               }
//             },
//           );
//         },
//         itemCount: videos.length,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
