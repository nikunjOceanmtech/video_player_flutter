import 'package:better_player/better_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';

class ReusableVideoListController {
  final List<BetterPlayerController> _betterPlayerControllerRegistry = [];
  final List<BetterPlayerController> _usedBetterPlayerControllerRegistry = [];

  ReusableVideoListController() {
    for (int index = 0; index < 3; index++) {
      _betterPlayerControllerRegistry.add(
        BetterPlayerController(
          const BetterPlayerConfiguration(
            handleLifecycle: false,
            autoDispose: false,
            autoDetectFullscreenAspectRatio: true,
            autoDetectFullscreenDeviceOrientation: false,
            fullScreenAspectRatio: 9 / 16,
            aspectRatio: 9 / 16,
            fit: BoxFit.scaleDown,
          ),
        ),
      );
    }
  }

  BetterPlayerController? getBetterPlayerController() {
    final freeController = _betterPlayerControllerRegistry
        .firstWhereOrNull((controller) => !_usedBetterPlayerControllerRegistry.contains(controller));

    if (freeController != null) {
      _usedBetterPlayerControllerRegistry.add(freeController);
    }

    return freeController;
  }

  void freeBetterPlayerController(BetterPlayerController? betterPlayerController) {
    _usedBetterPlayerControllerRegistry.remove(betterPlayerController);
  }

  void dispose() {
    for (var controller in _betterPlayerControllerRegistry) {
      controller.dispose();
    }
  }
}
