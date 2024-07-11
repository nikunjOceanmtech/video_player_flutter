// // ignore_for_file: avoid_single_cascade_in_expression_statements

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewPlayer extends StatefulWidget {
//   const WebViewPlayer({super.key});

//   @override
//   State<WebViewPlayer> createState() => _WebViewPlayerState();
// }

// class _WebViewPlayerState extends State<WebViewPlayer> {
//   late WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     loadWebView();
//   }

//   void loadWebView() {
//     controller = WebViewController()
//       ..loadHtmlString(
//           '<div style="position:relative;padding-top:56.25%;"><iframe src="https://iframe.mediadelivery.net/embed/84972/29d0d68f-bc31-4c9b-bd6a-bcbc0c526382?autoplay=true&loop=false&muted=false&preload=true&responsive=true" loading="lazy" style="border:0;position:absolute;top:0;height:100%;width:100%;" allow="accelerometer;gyroscope;autoplay;encrypted-media;picture-in-picture;" allowfullscreen="true"></iframe></div>')
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             print("On Page Ended ${progress}"); // controller.runJavaScript('plyer.fullscreen.enter()');
//           },
//           onPageStarted: (String url) {
//             print("On Page Started"); // controller.runJavaScript('plyer.fullscreen.enter()');
//           },
//           onPageFinished: (String url) {
//             print("On Page Ended");
//             // controller
//             //   ..addJavaScriptHandler(
//             //     handlerName: 'Ready',
//             //     callback: (_) {
//             //       _isPlayerReady = true;
//             //       if (_onLoadStopCalled) {
//             //         controller!.updateValue(
//             //           controller!.value.copyWith(isReady: true),
//             //         );
//             //       }
//             //     },
//             //   );

//             controller.runJavaScript('plyer.fullscreen.enter()');
//           },
//           onHttpError: (HttpResponseError error) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             return NavigationDecision.navigate;
//           },
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Embedded Video'),
//       ),
//       body: SizedBox(
//         child: WebViewWidget(
//           controller: controller,
//         ),
//       ),
//       floatingActionButton: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: InkWell(
//           onTap: () => loadWebView(),
//           child: Container(
//             height: 50,
//             color: Colors.green,
//             child: const Icon(Icons.fiber_new, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
