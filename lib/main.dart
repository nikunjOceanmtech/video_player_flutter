import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_flutter/global.dart';
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
  Map<int, WebViewController?> controllers = {};
  WebViewController? controller;
  PopupType popupType = PopupType.all;
  MenuController? menuController;

  int currentIndex = 0;
  int focusedIndex = 0;
  int reloadCounter = 0;

  bool isLoading = false;
  bool isPlaying = false;
  bool isIconShow = false;

  double duration = 0;
  double currentDuration = 0;

  String htmlData = '';
  String origionalHtmlData = '';
  List<String> listOfQualities = ["352", "640", "842", "1280", "1920"];
  List<String> listOfSpeeds = ["0.5", "0.75", "1", "1.25", "1.5", "1.75", "2", "4"];
  List<String> listOfSettingType = ["Qualitie", "Speed"];
  List<double> l1 = [];
  List<double> l2 = [];

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await clearCache();
        print("===================Resumed Call");
        break;
      case AppLifecycleState.paused:
        await clearCache();
        controllers[currentIndex]?.removeJavaScriptChannel("Duration");
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
        value?.removeJavaScriptChannel("Duration");
        value?.removeJavaScriptChannel("CurrentDuration");
        value?.removeJavaScriptChannel("Qualities");
        value?.clearCache();
        value?.clearLocalStorage();
      },
    );
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<String> getHTMLString() async {
    if (htmlData.trim().isNotEmpty) {
      return htmlData;
    }
    htmlData = await rootBundle.loadString('assets/player/index_browser.html');
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
      setState(() {});
      setState(() {});
      setState(() {});

      // print('🚀🚀🚀 INITIALIZED $index');
    }

    print('🚀🚀🚀 INITIALIZED $index : Keys ${controllers.keys.toList().toString()} '
        ' : Values ${controllers.values.toList().toString()}');
  }

  Future<void> playControllerAtIndex(int index) async {
    if (controllers.containsKey(index) && controllers[index] != null) {
      currentIndex = index;
      controller = controllers[index]!;
      duration = 0;
      await controller?.runJavaScript('flutterControl({ "command": "play", "parameter": null });');
      // loadDuration(controller: controllers[currentIndex], index: index);
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
      controllers[index]?.removeJavaScriptChannel("Duration");
      controllers[index]?.removeJavaScriptChannel("CurrentDuration");
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
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print("loading completed index : $index");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

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

  @override
  Widget build(BuildContext context) {
    print("Controllers Length : ${controllers.length}");
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: controllers.isEmpty
              ? Center(child: CircularProgressIndicator())
              : PageView.builder(
                  itemCount: controllers.length,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  reverse: false,
                  onPageChanged: (index) async {
                    int tempIndex = index;

                    print("===============");

                    if ((tempIndex == currentIndex) || (tempIndex < 0)) {
                      print("=====================1Already Loaded");
                      return;
                    }
                    if ((tempIndex == currentIndex) || (tempIndex >= videos.length)) {
                      print("====================2Already Loaded");
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
                      children: [
                        controllers[index] == null
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: WebViewWidget(
                                  controller: controllers[index]!,
                                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => TapGestureRecognizer()..onTap = _handleTap,
                                    ),
                                  },
                                ),
                              ),
                        // Container(
                        //   height: double.infinity,
                        //   width: double.infinity,
                        //   color: Colors.transparent,
                        // ),
                        // playAndPauseButton(context: context),
                        // volumeAndBackWordButton(context: context),
                        // forwordButton(context: context),
                        // // sliderView(index: index),
                        // settingView(),
                        // isLoading
                        //     ? Container(
                        //         height: double.infinity,
                        //         width: double.infinity,
                        //         color: p1Color.withOpacity(0.2),
                        //         alignment: Alignment.center,
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     : const SizedBox.shrink(),
                      ],
                    );
                  },
                ),
        ),
        // floatingActionButton: floatingButton(context: context),
      ),
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
              // js.context.callMethod("hello");
              // if (controller == null) return;
              // await controller!.runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
              print("=============${await controllers[currentIndex]?.currentUrl()}");
              await loadDuration(controller: controllers[currentIndex], index: currentIndex);
              print("=====================Duarion = $duration >>>>>>>>> Current Durarion = $currentDuration");
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
      onVerticalDragUpdate: (details) async {
        if (controller == null) return;
        if (details.primaryDelta! < 0) {
          await controller!.runJavaScript('flutterControl({ "command": "increaseVolume", "parameter": 0.01 });');
        } else if (details.primaryDelta! > 0) {
          await controller!.runJavaScript('flutterControl({ "command": "decreaseVolume", "parameter": 0.01 });');
        }
      },
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

  Widget sliderView({required int index}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
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
            currentDuration = value;
            setState(() {});
            await controller!.runJavaScript('flutterControl({ "command": "seek", "parameter": $value });');
          },
        ),
      ),
    );
  }

  Widget settingView() {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 80,
        width: 80,
        child: MenuAnchor(
          builder: (BuildContext context, MenuController controller, Widget? child) {
            return IconButton(
              onPressed: () {
                menuController = controller;
                popupType = PopupType.all;
                setState(() {});
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.settings, color: Colors.white),
            );
          },
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            shadowColor: WidgetStatePropertyAll(Colors.transparent),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          menuChildren: List<MenuItemButton>.generate(
            popupType == PopupType.all
                ? listOfSettingType.length
                : popupType == PopupType.qualities
                    ? listOfQualities.length + 1
                    : popupType == PopupType.speed
                        ? listOfSpeeds.length + 1
                        : 0,
            (int index) => MenuItemButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                elevation: WidgetStatePropertyAll(10),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                foregroundColor: WidgetStatePropertyAll(Colors.transparent),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
              ),
              child: index == 0 && (popupType == PopupType.qualities || popupType == PopupType.speed)
                  ? Container(
                      color: Colors.white,
                      height: 50,
                      width: 120,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => setState(() => popupType = PopupType.all),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded, color: p1Color),
                            SizedBox(width: 10),
                            Text(
                              "Back",
                              style: TextStyle(color: p1Color, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        if (popupType == PopupType.all) {
                          if (listOfSettingType[index] == "Qualitie") {
                            popupType = PopupType.qualities;
                            setState(() {});
                          } else if (listOfSettingType[index] == "Speed") {
                            popupType = PopupType.speed;
                            setState(() {});
                          }
                        } else if (popupType == PopupType.qualities) {
                          await controller?.runJavaScript(
                            'flutterControl({ "command": "qulitity", "parameter": ${listOfQualities[index - 1]} });',
                          );
                          menuController?.close();
                        } else if (popupType == PopupType.speed) {
                          await controller?.runJavaScript(
                            'flutterControl({ "command": "speed", "parameter": ${listOfSpeeds[index - 1]} });',
                          );
                          menuController?.close();
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        width: 120,
                        alignment: Alignment.center,
                        child: Text(
                          popupType == PopupType.all
                              ? listOfSettingType[index]
                              : popupType == PopupType.qualities
                                  ? "${listOfQualities[index - 1]}p"
                                  : popupType == PopupType.speed
                                      ? "${listOfSpeeds[index - 1]}x"
                                      : "0",
                          style: TextStyle(color: p1Color, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    if (controller == null) return;
    isIconShow = true;
    setState(() {});
    Future.delayed(Duration(seconds: 1), () => setState(() => isIconShow = false));
    isPlaying = !isPlaying;
    await controller!.runJavaScript('flutterControl({ "command": "togglePlay", "parameter": null });');
  }

  Future<void> loadDuration({required WebViewController? controller, required int index}) async {
    print("============Load duration called");
    setState(() {});
    // await controller?.reload();
    await controller?.addJavaScriptChannel(
      "Duration",
      onMessageReceived: (value) {
        if (duration == 0) {
          duration = double.tryParse(value.message) ?? 0;
        }
      },
    );
    await controller?.addJavaScriptChannel(
      "CurrentDuration",
      onMessageReceived: (value) {
        print("===================CurrentDuration${value.message}");
        currentDuration = double.tryParse(value.message) ?? 0;
        setState(() {});
      },
    );
  }
}
