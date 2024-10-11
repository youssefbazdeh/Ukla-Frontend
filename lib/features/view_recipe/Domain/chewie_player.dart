import 'dart:async';
import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/view_recipe/Data/video_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerRegistry {
  static BetterPlayerController? _controller;

  static void registerController(BetterPlayerController controller) {
    _controller = controller;
  }

  static void pause() {
    if (_controller != null) _controller!.pause();
  }

  static void resume() {
    if (_controller != null) _controller!.play();
  }

  static void dispose() {
    _controller!.dispose();
  }
}

class ChewiVideoAsset extends StatefulWidget {
  final String videoUrl;
  final int? recipeId;
  const ChewiVideoAsset({Key? key, required this.videoUrl,this.recipeId}) : super(key: key);

  @override
  State<ChewiVideoAsset> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<ChewiVideoAsset>
    with AutomaticKeepAliveClientMixin {
  late Future<void> _initVideoFuture;
  late BetterPlayerController _betterPlayerController;
  bool _isFullScreen = false;
  Timer? _playbackTimer;
  static const String _viewedVideosKey = 'viewedVideos';
  late double videoAspectRation = 0;

  @override
  void initState() {
    super.initState();
    _initVideoFuture = initVideo();
  }

  Future<bool> hasUserViewedVideo(int recipeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? viewedVideosJson = prefs.getString(_viewedVideosKey);
    if (viewedVideosJson == null) return false;

    List<Map<String, dynamic>> viewedVideos = List<Map<String, dynamic>>.from(jsonDecode(viewedVideosJson));
    DateTime now = DateTime.now();
    for (var video in viewedVideos) {
      if (video['id'] == recipeId.toString() && now.difference(DateTime.parse(video['timestamp'])).inHours <= 3) {
        return true;
      }
    }
    return false;
  }

  Future<void> markVideoAsViewed(int recipeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? viewedVideosJson = prefs.getString(_viewedVideosKey);
    List<Map<String, dynamic>> viewedVideos = viewedVideosJson == null ? [] : List<Map<String, dynamic>>.from(jsonDecode(viewedVideosJson));

    viewedVideos.add({'id': recipeId.toString(), 'timestamp': DateTime.now().toIso8601String()});
    await prefs.setString(_viewedVideosKey, jsonEncode(viewedVideos));
  }

  Future<void> removeExpiredViews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? viewedVideosJson = prefs.getString(_viewedVideosKey);
    if (viewedVideosJson == null) return;

    List<Map<String, dynamic>> viewedVideos = List<Map<String, dynamic>>.from(jsonDecode(viewedVideosJson));
    DateTime now = DateTime.now();
    viewedVideos.removeWhere((video) => now.difference(DateTime.parse(video['timestamp'])).inHours > 3);

    await prefs.setString(_viewedVideosKey, jsonEncode(viewedVideos));
  }

  Future<void> incrementViews(int recipeId) async {
    bool hasViewed = await hasUserViewedVideo(recipeId);

    if (!hasViewed) {
      await incrementViewsCount(recipeId);
      await markVideoAsViewed(recipeId);
    }
  }

  void startExpiredViewsCheck() {
    Timer.periodic(const Duration(hours: 24), (timer) async {
      await removeExpiredViews();
    });
  }

  Future<void> initVideo() async {
    try {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 5000,
          maxBufferMs: 13000,
          bufferForPlaybackMs: 2500,
          bufferForPlaybackAfterRebufferMs: 5000,
        ),
      );

      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoDispose: true,
          autoPlay: true,
          autoDetectFullscreenAspectRatio: true,
          autoDetectFullscreenDeviceOrientation: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            controlBarColor: Colors.black.withOpacity(0.5),
            enablePip: false,
            enableFullscreen: true,
            enableSubtitles: false,
            loadingColor: Colors.white,
            progressBarBufferedColor: AppColors.secondaryColor,
            progressBarHandleColor: Colors.white,
            progressBarBackgroundColor: Colors.white,
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );
      _betterPlayerController.addEventsListener((BetterPlayerEvent event) async {
        if (event.betterPlayerEventType == BetterPlayerEventType.changedPlayerVisibility) {
          _isFullScreen = _betterPlayerController.isFullScreen ;
          if (_isFullScreen) {
            _betterPlayerController.play();
          }
        }
      });

      _betterPlayerController.addEventsListener((BetterPlayerEvent event) async {
        if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
          String newUrl = await updateVideoUrl(widget.videoUrl);
          if (newUrl.isNotEmpty) {
            await _betterPlayerController.setupDataSource(
              BetterPlayerDataSource(
                BetterPlayerDataSourceType.network,
                newUrl,
                bufferingConfiguration: const BetterPlayerBufferingConfiguration(
                  minBufferMs: 2000,
                  maxBufferMs: 2000,
                  bufferForPlaybackMs: 2000,
                  bufferForPlaybackAfterRebufferMs: 2000,
                ),
              ),
            );
            _betterPlayerController.play();
          }
        }
      });

      _betterPlayerController.addEventsListener((BetterPlayerEvent event) async {
        if (event.betterPlayerEventType == BetterPlayerEventType.play) {
          incrementViewsAfter3seconds();
        }
      });

      _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          if(_betterPlayerController.videoPlayerController!.value.aspectRatio > 1){
            _betterPlayerController.setOverriddenAspectRatio(16/10);

          }else{
            _betterPlayerController.setOverriddenAspectRatio(_betterPlayerController.videoPlayerController!.value.aspectRatio + 0.02);
          }
          setState(() {});
        }
      });

      _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          setState(() {
            videoAspectRation = _betterPlayerController.getAspectRatio()!;
          });
        }
      });

      VideoPlayerRegistry.registerController(_betterPlayerController);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }


  void incrementViewsAfter3seconds() {
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_betterPlayerController.isPlaying() == true) {
        if (timer.tick >= 3) {
          if(widget.recipeId != null){
            await incrementViews(widget.recipeId!);
          }
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }



  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _initVideoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return VisibilityDetector(
            key: const Key('VideoPlayerKey'),
            onVisibilityChanged: (visibility) {
              if (!_isFullScreen &&
                  (visibility.visibleFraction <= 0.4) &&
                  (mounted) &&
                  _betterPlayerController.isPlaying()!) {
                _betterPlayerController.pause();
              }
            },
            child: BetterPlayer(controller: _betterPlayerController),
          );
        } else{
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.secondaryColor,
              strokeWidth: 2.0,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    VideoPlayerRegistry.dispose();
    _playbackTimer?.cancel();
    super.dispose();
  }
}
