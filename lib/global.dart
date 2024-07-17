import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

enum PopupType { all, qualities, speed }

String get userAgent =>
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36';

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

class WebViewModel {
  WebViewController? webViewController;
  double duration;
  double currentDuration;
  List<String> listOfQulitiy;

  WebViewModel({
    this.webViewController,
    required this.duration,
    required this.currentDuration,
    required this.listOfQulitiy,
  });
}

Color p1Color = Color(0xff084277);
