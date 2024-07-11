// // ignore_for_file: avoid_single_cascade_in_expression_statements

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewPlayer extends StatefulWidget {
//   const WebViewPlayer({super.key});

//   @override
//   State<WebViewPlayer> createState() => _WebViewPlayerState();
// }

// class _WebViewPlayerState extends State<WebViewPlayer> {
//   late InAppWebViewController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Embedded Video'),
//       ),
//       body: SizedBox(
//         child: InAppWebView(
//           key: widget.key,
//           initialData: InAppWebViewInitialData(
//             data: "player",
//             baseUrl: WebUri.uri(Uri.https('www.youtube.com')),
//             encoding: 'utf-8',
//             mimeType: 'text/html',
//           ),
//           initialSettings: InAppWebViewSettings(
//             userAgent: userAgent,
//             mediaPlaybackRequiresUserGesture: false,
//             transparentBackground: true,
//             disableContextMenu: true,
//             supportZoom: false,
//             disableHorizontalScroll: false,
//             disableVerticalScroll: false,
//             allowsInlineMediaPlayback: true,
//             allowsAirPlayForMediaPlayback: true,
//             allowsPictureInPictureMediaPlayback: true,
//             useWideViewPort: false,
//           ),
//           onWebViewCreated: (webController) {
//             controller = webController;

//             webController
//               ..addJavaScriptHandler(
//                 handlerName: 'Ready',
//                 callback: (_) {
//                   // _isPlayerReady = true;
//                   // if (_onLoadStopCalled) {
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(isReady: true),
//                   // );
//                   // }
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: 'StateChange',
//                 callback: (args) {
//                   switch (args.first as int) {
//                     case -1:
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.unStarted,
//                       //     isLoaded: true,
//                       //   ),
//                       // );
//                       break;
//                     case 0:
//                       // widget.onEnded?.call(controller!.metadata);
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.ended,
//                       //   ),
//                       // );
//                       break;
//                     case 1:
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.playing,
//                       //     isPlaying: true,
//                       //     hasPlayed: true,
//                       //     errorCode: 0,
//                       //   ),
//                       // );
//                       break;
//                     case 2:
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.paused,
//                       //     isPlaying: false,
//                       //   ),
//                       // );
//                       break;
//                     case 3:
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.buffering,
//                       //   ),
//                       // );
//                       break;
//                     case 5:
//                       // controller!.updateValue(
//                       //   controller!.value.copyWith(
//                       //     playerState: PlayerState.cued,
//                       //   ),
//                       // );
//                       break;
//                     default:
//                       throw Exception("Invalid player state obtained.");
//                   }
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: '',
//                 callback: (args) {
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(playbackQuality: args.first as String),
//                   // );
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: 'PlaybackRateChange',
//                 callback: (args) {
//                   // final num rate = args.first;
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(playbackRate: rate.toDouble()),
//                   // );
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: 'Errors',
//                 callback: (args) {
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(errorCode: int.parse(args.first)),
//                   // );
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: 'VideoData',
//                 callback: (args) {
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(metaData: YoutubeMetaData.fromRawData(args.first)),
//                   // );
//                 },
//               )
//               ..addJavaScriptHandler(
//                 handlerName: 'VideoTime',
//                 callback: (args) {
//                   // final position = args.first * 1000;
//                   // final num buffered = args.last;
//                   // controller!.updateValue(
//                   //   controller!.value.copyWith(
//                   //     position: Duration(milliseconds: position.floor()),
//                   //     buffered: buffered.toDouble(),
//                   //   ),
//                   // );
//                 },
//               );
//           },
//           onLoadStop: (_, __) {
//             // _onLoadStopCalled = true;
//             // if (_isPlayerReady) {
//             // controller!.updateValue(
//             //   controller!.value.copyWith(isReady: true),
//             // );
//             // }
//           },
//         ),
//       ),
//       floatingActionButton: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: InkWell(
//           // onTap: () => loadWebView(),
//           child: Container(
//             height: 50,
//             color: Colors.green,
//             child: const Icon(Icons.fiber_new, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   String boolean({required bool value}) => value == true ? "'1'" : "'0'";

//   String get userAgent =>
//       'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36';
// }
