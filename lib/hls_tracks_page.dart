// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HlsTracksPage extends StatefulWidget {
  const HlsTracksPage({super.key});

  @override
  _HlsTracksPageState createState() => _HlsTracksPageState();
}

class _HlsTracksPageState extends State<HlsTracksPage> {
  BetterPlayerController? _betterPlayerController;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
  }

  bool videoLoading = false;

  int startTimeMs = 0;
  int endTimeMs = 0;

  Future<void> playVideo({required String videoURL}) async {
    if (videoLoading) return;

    currentURL = videoURL;

    _betterPlayerController?.clearCache();
    await _betterPlayerController?.pause();

    setState(() {
      videoLoading = true;
      startTimeMs = 0;
      endTimeMs = 0;
      error = '';
    });

    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      fit: BoxFit.scaleDown,
      autoPlay: true,
      autoDispose: true,
      autoDetectFullscreenAspectRatio: true,
      fullScreenByDefault: false,
      deviceOrientationsOnFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: 9 / 16,
      controlsConfiguration: BetterPlayerControlsConfiguration(enableFullscreen: false),
    );

    stopwatch.reset();
    stopwatch.start();

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoURL,
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 3000,
        maxBufferMs: 8000,
        bufferForPlaybackMs: 2000,
        bufferForPlaybackAfterRebufferMs: 2500,
      ),
      videoFormat: videoURL.endsWith('m3u8') ? BetterPlayerVideoFormat.hls : BetterPlayerVideoFormat.other,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController!.setupDataSource(dataSource).then((value) {
      setState(() {
        videoLoading = false;
        error = '';
      });
    }).onError(
      (error, stackTrace) {
        setState(() {
          this.error = error.toString();
          _betterPlayerController = null;
          videoLoading = false;
        });
      },
    );

    print("STOPWATCH TIME Start : ${stopwatch.elapsedMilliseconds}");
    _betterPlayerController?.addEventsListener(
      (p0) {
        if (p0.betterPlayerEventType == BetterPlayerEventType.initialized) {
          stopwatch.start();
          endTimeMs = stopwatch.elapsedMilliseconds;
          setState(() {});
          print("STOPWATCH TIME Start initialized : ${stopwatch.elapsedMilliseconds}");
        }
        if (p0.betterPlayerEventType == BetterPlayerEventType.bufferingStart) {
          stopwatch.start();
          startTimeMs = stopwatch.elapsedMilliseconds;
          setState(() {});
          print("STOPWATCH TIME Start : ${stopwatch.elapsedMilliseconds}");
        }
        if (p0.betterPlayerEventType == BetterPlayerEventType.bufferingEnd) {
          stopwatch.stop();
          setState(() {
            endTimeMs = stopwatch.elapsedMilliseconds;
          });
          print("STOPWATCH TIME END : ${stopwatch.elapsedMilliseconds}");
          stopwatch.reset();
        }
      },
    );
  }

  String currentURL = '';
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Player Demo",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              ClipboardData? data = await Clipboard.getData("text/plain");
              if (data != null && data.text != null) {
                String dataURL = data.text!;
                if (dataURL.endsWith('.mp4') ||
                    dataURL.endsWith('.mkv') ||
                    dataURL.endsWith('.m4v') ||
                    dataURL.endsWith('.m3u8')) {
                  playVideo(videoURL: dataURL);
                } else {
                  error =
                      "Only Accepted format are .mp4 and .m3u8 urls & Founded format are .${dataURL.split('.').last}";
                  setState(() {});
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Icon(Icons.paste),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: error.toString().trim().isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          error.toString().trim(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : videoLoading
                        ? const CircularProgressIndicator()
                        : _betterPlayerController == null
                            ? Text(
                                "Please select from below streams",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            : AspectRatio(
                                aspectRatio: _betterPlayerController!.getAspectRatio() ?? 1,
                                child: BetterPlayer(controller: _betterPlayerController!),
                              ),
              ),
            ),
            currentURL.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 8),
            currentURL.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Text(
                      "Current Video : $currentURL",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
            currentURL.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Start : $startTimeMs ms / ${startTimeMs / 1000} sec",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Ends : $endTimeMs ms / ${endTimeMs / 1000} sec",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: linkAndLabel(
                      context,
                      link: "https://oceanmtech.b-cdn.net/dmt/reel_video/20230713160123-d5d34u.mp4",
                      lable: "MP4(26.89MB)",
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: linkAndLabel(
                      context,
                      link: "https://oceanmtech.b-cdn.net/test/original.mp4",
                      lable: "MP4(68.09MB)",
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: linkAndLabel(
                      context,
                      link: "https://vz-352e339f-24b.b-cdn.net/fd347769-aa48-42bd-ab7d-1656d5ff84aa/playlist.m3u8",
                      lable: "HLS(12.37MB)",
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: linkAndLabel(
                      context,
                      link: "https://vz-352e339f-24b.b-cdn.net/be21ea4d-ecea-4239-a1fc-bd1f9f58651b/playlist.m3u8",
                      lable: "HLS(151.15MB)",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: linkAndLabel(
                      context,
                      link: "https://vz-352e339f-24b.b-cdn.net/64ed8c7c-daf3-4d15-ad7f-2095fa4efabb/playlist.m3u8",
                      lable: "M3U8-46RS(60MB)",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  InkWell linkAndLabel(BuildContext context, {required String link, required String lable}) {
    return InkWell(
      onTap: () => playVideo(videoURL: link),
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        color: Colors.green,
        child: Text(
          lable,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
