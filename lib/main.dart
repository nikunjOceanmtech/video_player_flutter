// ignore_for_file: dead_code, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearCache();
  runApp(const MaterialApp(home: WebViewScreen()));
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with WidgetsBindingObserver {
  final List<String> videos = [
    "2e442126-bcdd-46c4-96be-4683cab9d8f5",
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
    "5b0b1725-45d0-4135-ad50-ae66902e2f82",
    "bae2612b-a1ad-4e0c-b3f9-22904258a16c",
    "fd347769-aa48-42bd-ab7d-1656d5ff84aa",
  ];

  Map<int, WebViewController?> controllers = {};

  int currentIndex = 0;
  WebViewController? controller;
  int focusedIndex = 0;
  int reloadCounter = 0;
  bool isLoading = false;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await clearCache();
        print("===================Resumed Call");
        break;
      case AppLifecycleState.paused:
        await clearCache();
        print("===================Paused Call");
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // loadVideo(index: 0);
    _playNext(0);
  }

  @override
  void dispose() {
    controllers.forEach(
      (key, value) {
        value?.clearCache();
        value?.clearLocalStorage();
      },
    );
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String htmlData = '';
  String origionalHtmlData = '';

  Future<String> getHTMLString() async {
    if (htmlData.trim().isNotEmpty) {
      return htmlData;
    }
    htmlData = await rootBundle.loadString('assets/index.html');
    return htmlData;
  }

  Future _initializeControllerAtIndex(int index) async {
    // print("Initilized" + index.toString());
    // print("Initilized" + ((state as ReelsHomeLoadedState).reelsUrls.length > index && index >= 0).toString());
    if (videos.length > index &&
        index >= 0 &&
        (!controllers.keys.contains(index) || (controllers.keys.contains(index) && controllers[index] == null))) {
      /// Create new controller

      String videoId = videos[index];

      final WebViewController controller = loadController(index: index);
      await controller.loadHtmlString(
        (await getHTMLString())
            .replaceAll('{{videoid}}', videoId)
            .replaceAll('{{autoplay}}', index == currentIndex ? 'true' : 'false'),
      );

      /// Add to [controllers] list
      controllers[index] = controller;

      if (index != 0) {
        await stopControllerAtIndex(index);
      }

      // print('🚀🚀🚀 INITIALIZED $index');
    }

    print('🚀🚀🚀 INITIALIZED $index : Keys ${controllers.keys.toList().toString()} '
        ' : Values ${controllers.values.toList().toString()}');
  }

  Future<void> playControllerAtIndex(int index) async {
    if (controllers.containsKey(index) && controllers[index] != null) {
      currentIndex = index;
      controller = controllers[index]!;
      await controller!.addJavaScriptChannel(
        "Duration",
        onMessageReceived: (p0) {
          if (duration == 0) {
            duration = double.tryParse(p0.message) ?? 0;
            setState(() {});
          }
        },
      );
      await controller!.addJavaScriptChannel(
        "CurrentDuration",
        onMessageReceived: (p0) {
          currentDuration = double.tryParse(p0.message) ?? 0;
          setState(() {});
        },
      );
      await controller?.runJavaScript('flutterControl({ "command": "play", "parameter": null });');
      print('🚀🚀🚀 INITIALIZED Playing Index : $index}');
      Future.delayed(Duration.zero, () => setState(() {}));
    } else {
      await _initializeControllerAtIndex(index);
      await playControllerAtIndex(index);
    }
  }

  Future<void> playControllerNow(int index) async {
    if (controllers.containsKey(index) && controllers[index] != null) {
      await controllers[index]?.runJavaScript('flutterControl({ "command": "play", "parameter": null });');
    }
  }

  Future<void> stopControllerAtIndex(int index) async {
    if (controllers.containsKey(index) && controllers[index] != null) {
      await controllers[index]?.runJavaScript('flutterControl({ "command": "pause", "parameter": null });');
    }
  }

  Future<void> _disposeControllerAtIndex(int index) async {
    if (controllers.keys.contains(index) && controllers[index] != null) {
      await stopControllerAtIndex(index);
      controllers[index]?.clearCache();
      controllers[index]?.clearLocalStorage();
      controllers[index] = null;
      print("Controllrs Length ${controllers.length} & elements keys : ${controllers.keys.toList().toString()}");
    }
  }

  WebViewController loadController({required int index}) {
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
            print("loading completed index : $index");
            isLoading = false;
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  double duration = 0;
  double currentDuration = 0;

  Future<void> _playNext(int index) async {
    /// Stop [index - 1] controller
    await stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    await _disposeControllerAtIndex(index - 5);

    /// Play current Reels (already initialized)

    await playControllerAtIndex(index);

    /// Initialize [index + 1] controller

    if (controllers.containsKey(index + 1) && controllers[index + 1] != null) {
      if (controllers.containsKey(index + 2) && controllers[index + 2] != null) {
        if (controllers.containsKey(index + 3) && controllers[index + 3] != null) {
          await _initializeControllerAtIndex(index + 4);
          await _initializeControllerAtIndex(index + 5);
          await _initializeControllerAtIndex(index + 6);
          return;
        }
        await _initializeControllerAtIndex(index + 3);
        await _initializeControllerAtIndex(index + 4);
        await _initializeControllerAtIndex(index + 5);
        return;
      }
      await _initializeControllerAtIndex(index + 2);
      await _initializeControllerAtIndex(index + 3);
      await _initializeControllerAtIndex(index + 4);
      return;
    } else {
      await _initializeControllerAtIndex(index + 1);
      await _initializeControllerAtIndex(index + 2);
      await _initializeControllerAtIndex(index + 3);
      return;
    }
  }

  Future<void> _playPrevious(int index) async {
    /// Stop [index + 1] controller
    await stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    await _disposeControllerAtIndex(index + 5);

    /// Play current Reels (already initialized)

    await playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    if (controllers.containsKey(index - 1) && controllers[index - 1] != null) {
      if (controllers.containsKey(index - 2) && controllers[index - 2] != null) {
        if (controllers.containsKey(index - 3) && controllers[index - 3] != null) {
          await _initializeControllerAtIndex(index - 4);
          await _initializeControllerAtIndex(index - 5);
          await _initializeControllerAtIndex(index - 6);
          return;
        }
        await _initializeControllerAtIndex(index - 3);
        await _initializeControllerAtIndex(index - 4);
        await _initializeControllerAtIndex(index - 5);
        return;
      }
      await _initializeControllerAtIndex(index - 2);
      await _initializeControllerAtIndex(index - 3);
      await _initializeControllerAtIndex(index - 4);
      return;
    } else {
      await _initializeControllerAtIndex(index - 2);
      await _initializeControllerAtIndex(index - 3);
      await _initializeControllerAtIndex(index - 4);
      return;
    }
  }

  String get userAgent =>
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36';

  @override
  Widget build(BuildContext context) {
    print("Controllers Length : ${controllers.length}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: controllers.isEmpty
            ? Center(child: CircularProgressIndicator())
            : PageView.builder(
                itemCount: controllers.length,
                scrollDirection: Axis.vertical,
                onPageChanged: (value) {
                  int tempIndex = value;

                  if ((tempIndex == currentIndex) || (tempIndex < 0)) {
                    print("Already Loaded");
                    return;
                  }
                  if ((tempIndex == currentIndex) || (tempIndex >= videos.length)) {
                    print("Already Loaded");
                    return;
                  }

                  if (tempIndex > focusedIndex) {
                    _playNext(tempIndex);
                  } else {
                    _playPrevious(tempIndex);
                  }
                  focusedIndex = tempIndex;
                },
                itemBuilder: (context, index) {
                  return Stack(
                    // fit: StackFit.expand,
                    children: [
                      controllers[index] == null
                          ? Center(child: CircularProgressIndicator())
                          : WebViewWidget(
                              controller: controllers[index]!,
                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => TapGestureRecognizer()..onTap = _handleTap,
                                ),
                              },
                            ),
                      playAndPauseButton(context: context),
                      volumeAndBackWordButton(context: context),
                      forwordButton(context: context),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80,
                          child: Slider(
                            value: currentDuration,
                            max: duration,
                            thumbColor: Colors.transparent,
                            activeColor: Colors.amber,
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            inactiveColor: Colors.red,
                            secondaryActiveColor: Colors.amber,
                            autofocus: false,
                            onChanged: (value) async {
                              await controller!.runJavaScript(
                                'flutterControl({ "command": "seek", "parameter": $value });',
                              );
                              print("=============$value");
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      // floatingActionButton: floatingButton(context: context),
    );
  }

  Widget floatingButton({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: FloatingActionButton(
            onPressed: () async {
              if (controller == null) return;
              await controller!.runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
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
    );
  }

  Widget playAndPauseButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () async => await _handleTap(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.90,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: isIconShow
              ? Image.asset(
                  !isPlaying ? "assets/pause.png" : "assets/play.png",
                  height: 50,
                  width: 50,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget volumeAndBackWordButton({required BuildContext context}) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onTap: () async => await controller!.runJavaScript('flutterControl({ "command": "rewind", "parameter": 10 });'),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 100,
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.transparent,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget forwordButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () async => await controller!.runJavaScript('flutterControl({ "command": "forward", "parameter": 10 });'),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 100,
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.transparent,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Future<void> _onVerticalDragUpdate(DragUpdateDetails details) async {
    if (controller == null) return;
    if (details.primaryDelta! < 0) {
      await controller!.runJavaScript('flutterControl({ "command": "increaseVolume", "parameter": 0.01 });');
    } else if (details.primaryDelta! > 0) {
      await controller!.runJavaScript('flutterControl({ "command": "decreaseVolume", "parameter": 0.01 });');
    }
  }

  bool isPlaying = false;
  bool isIconShow = false;

  Future<void> _handleTap() async {
    if (controller == null) return;
    isIconShow = true;
    setState(() {});
    Future.delayed(Duration(seconds: 1), () => setState(() => isIconShow = false));
    isPlaying = !isPlaying;
    await controller!.runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
  }
}

Future<void> clearCache() async {
  try {
    cleanUpMemory();
    await DefaultCacheManager().emptyCache();
    var tempDir = await getTemporaryDirectory();
    await tempDir.delete(recursive: true);
    var appDocDir = await getApplicationDocumentsDirectory();
    await appDocDir.delete(recursive: true);
    print("Cache cleared");
  } catch (e) {
    print("Error clearing cache: $e");
  }
}

void cleanUpMemory() {
  ImageCache imageCache = PaintingBinding.instance.imageCache;

  if (imageCache.currentSizeBytes >= 55 << 20 || imageCache.currentSize >= 50) {
    imageCache.clear();
  }
  if (imageCache.liveImageCount >= 20) {
    imageCache.clearLiveImages();
  }
}
