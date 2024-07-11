// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player_flutter/reusable_video_list/reusable_video_list_controller.dart';
import 'package:video_player_flutter/reusable_video_list/reusable_video_list_widget.dart';
import 'package:video_player_flutter/reusable_video_list/video_list_data.dart';

class ReusableVideoListPage extends StatefulWidget {
  const ReusableVideoListPage({super.key});

  @override
  _ReusableVideoListPageState createState() => _ReusableVideoListPageState();
}

class _ReusableVideoListPageState extends State<ReusableVideoListPage> {
  ReusableVideoListController videoListController = ReusableVideoListController();
  final List<String> _videos = [
    "https://vz-352e339f-24b.b-cdn.net/29d0d68f-bc31-4c9b-bd6a-bcbc0c526382/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/f0b2c6bc-38c9-4049-8c7b-a09708f95d6c/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/29d0d68f-bc31-4c9b-bd6a-bcbc0c526382/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/f0b2c6bc-38c9-4049-8c7b-a09708f95d6/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/64601abb-7fdc-4bf7-9cdd-fcdf4069ae7b/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/93879e07-badc-46c0-88eb-3622c963cae6/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/328b752b-c488-47b0-8203-ba002d20be63/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/759c85af-c027-4622-820a-54d9fb8a7a95/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/a3a483c0-5e5a-403a-ac45-140eb88bb869/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/867d1bf9-0968-4fed-9d24-f1979fcf19e4/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/64ed8c7c-daf3-4d15-ad7f-2095fa4efabb/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/673d7730-a277-45fa-8fff-ea1369765859/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/d789d391-054c-42dd-a4c9-6e7065e5bb65/playlist.m3u8",
    "https://vz-352e339f-24b.b-cdn.net/01c8daad-3017-4d5c-8496-557e12c29034/playlist.m3u8",
  ];
  List<VideoListData> dataList = [];
  var value = 0;
  final PageController _scrollController = PageController();
  int lastMilli = DateTime.now().millisecondsSinceEpoch;
  bool _canBuildVideo = true;

  @override
  void initState() {
    _setupData();
    super.initState();
  }

  void _setupData() {
    for (int index = 0; index < _videos.length; index++) {
      dataList.add(VideoListData("Video $index", _videos[index]));
    }
  }

  @override
  void dispose() {
    videoListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final now = DateTime.now();
          final timeDiff = now.millisecondsSinceEpoch - lastMilli;
          if (notification is ScrollUpdateNotification) {
            final pixelsPerMilli = notification.scrollDelta! / timeDiff;
            if (pixelsPerMilli.abs() > 1) {
              _canBuildVideo = false;
            } else {
              _canBuildVideo = true;
            }
            lastMilli = DateTime.now().millisecondsSinceEpoch;
          }

          if (notification is ScrollEndNotification) {
            _canBuildVideo = true;
            lastMilli = DateTime.now().millisecondsSinceEpoch;
          }

          return true;
        },
        child: PageView.builder(
          itemCount: dataList.length,
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            VideoListData videoListData = dataList[index];
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ReusableVideoListWidget(
                videoListData: videoListData,
                videoListController: videoListController,
                canBuildVideo: _checkCanBuildVideo,
              ),
            );
          },
        ),
      ),
    );
  }

  bool _checkCanBuildVideo() {
    return _canBuildVideo;
  }
}
