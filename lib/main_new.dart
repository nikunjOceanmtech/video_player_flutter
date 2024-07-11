// ignore_for_file: dead_code, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaterialApp(home: WebViewScreen()));
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    currentController = loadController();
    previousController = loadController();
    nextController = loadController();
    loadVideo(index: 0);
  }

  String htmlData = '';
  String originalHtmlData = '';

  bool isLoading = false;
  WebViewController? previousController;
  WebViewController? currentController;
  WebViewController? nextController;

  final List<String> videos = [
    "29d0d68f-bc31-4c9b-bd6a-bcbc0c526382",
    "f0b2c6bc-38c9-4049-8c7b-a09708f95d6c",
    "29d0d68f-bc31-4c9b-bd6a-bcbc0c526382",
    "f0b2c6bc-38c9-4049-8c7b-a09708f95d6c",
    "64601abb-7fdc-4bf7-9cdd-fcdf4069ae7b",
    "93879e07-badc-46c0-88eb-3622c963cae6",
    "328b752b-c488-47b0-8203-ba002d20be63",
    "759c85af-c027-4622-820a-54d9fb8a7a95",
    "a3a483c0-5e5a-403a-ac45-140eb88bb869",
    "867d1bf9-0968-4fed-9d24-f1979fcf19e4",
    "64ed8c7c-daf3-4d15-ad7f-2095fa4efabb",
    "673d7730-a277-45fa-8fff-ea1369765859",
    "d789d391-054c-42dd-a4c9-6e7065e5bb65",
    "01c8daad-3017-4d5c-8496-557e12c29034",
  ];

  final List<String> loadedVideos = [];
  String previousVideoId = '';
  String nextVideoId = '';
  String currentVideoVideoId = '';
  int currentIndex = 0;

  Future<void> loadVideo({required int index}) async {
    if (htmlData.trim().isEmpty || originalHtmlData.toString().trim().isEmpty) {
      String htmlFileData = await rootBundle.loadString('assets/index.html');
      htmlData = htmlFileData;
      originalHtmlData = htmlFileData;
    }

    if (index < 0 || (index >= videos.length)) return;

    if (index > 0 && currentController != null && index > currentIndex) {
      previousVideoId = currentVideoVideoId;
      previousController = currentController;
    }

    if (index < videos.length - 1 && nextController != null) {
      String nextVideoId = videos[index + 1];
      String nextHtmlData = originalHtmlData.replaceAll('{{videoid}}', nextVideoId);
      await nextController!.loadHtmlString(nextHtmlData);
    }

    currentIndex = index;
    String videoId = videos[index];
    htmlData = originalHtmlData.replaceAll('{{videoid}}', videoId);

    if (currentController != null) {
      currentVideoVideoId = videoId;
      if (previousVideoId == currentVideoVideoId) {
        currentController = previousController;
      } else if (nextVideoId == currentVideoVideoId) {
        currentController = nextController;
      } else {
        await currentController!.loadHtmlString(htmlData);
      }
    }
  }

  WebViewController loadController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            isLoading = true;
          },
          onPageFinished: (String url) {
            isLoading = false;
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  String get userAgent =>
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            currentController == null
                ? Center(child: CircularProgressIndicator())
                : IgnorePointer(
                    ignoring: true,
                    child: WebViewWidget(
                      controller: currentController!,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => TapGestureRecognizer()..onTap = _handleTap,
                        ),
                      },
                    ),
                  ),
            GestureDetector(
              onPanEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy > 600) {
                  loadVideo(index: currentIndex - 1);
                  print("Load Previous");
                } else if (details.velocity.pixelsPerSecond.dy < -600) {
                  loadVideo(index: currentIndex + 1);
                  print("Load Next");
                }
              },
              onTap: () async => await _handleTap(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: FloatingActionButton(
              onPressed: () async {
                if (currentController == null) return;
                await currentController!
                    .runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow),
                  Text("/", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 26)),
                  Icon(Icons.pause),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap() async {
    if (currentController == null) return;
    await currentController!.runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
  }
}
