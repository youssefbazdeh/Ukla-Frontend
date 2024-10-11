import 'dart:async';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_button/timer_button.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/view_recipe/Data/video_service.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../ads/Presentation/bloc/banner_ad_bloc.dart';
import '../../ads/Presentation/bloc/banner_ad_event.dart';

class BannerAdVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int? bannerId;
  const BannerAdVideoPlayerWidget({Key? key, required this.videoUrl, this.bannerId}) : super(key: key);

  @override
  State<BannerAdVideoPlayerWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<BannerAdVideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  late Future<void> _initVideoFuture;
  late BetterPlayerController _betterPlayerController;
  bool _isFullScreen = false;
  Timer? _playbackTimer;
  late double videoAspectRation = 0;
  Timer? _countDown;
  late int timeLeft;

  @override
  void initState() {
    super.initState();
    _initVideoFuture = initVideo();
    timeLeft = 5;
  }

  void _startCountdown() {
    _countDown = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeLeft!= 0 && timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        t.cancel();
      }
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
          autoDetectFullscreenAspectRatio: true,
          autoDetectFullscreenDeviceOrientation: true,
          autoPlay: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            controlBarColor: Colors.black.withOpacity(0.5),
            controlBarHeight: 30,
            enablePip: false,
            enableRetry: false,
            enableSkips: false,
            enableFullscreen: true,
            enableSubtitles: false,
            loadingColor: Colors.white,
            progressBarBufferedColor: AppColors.secondaryColor,
            progressBarHandleColor: Colors.white,
            progressBarBackgroundColor: Colors.white,
            showControls: true,
            showControlsOnInitialize: false,
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
          _startCountdown();
          BlocProvider.of<BannerAdBloc>(context).add(IncrementViewEvent(widget.bannerId!));
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

      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
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
            child: Stack(
              children: [
                BetterPlayer(controller: _betterPlayerController),
                Positioned(
                  bottom: 60,
                  right: 0,
                  child: Container(
                    height: 30,
                    color: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TimerButton.builder(
                      builder: (context, timeleft){
                        String buttonText = timeLeft == 0? "Skip ad" : "$timeLeft";
                        return Row(
                          children:[
                            if(timeLeft!=0)...[
                              Text(
                                "$buttonText | Skip in",
                                style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal),
                              ),
                            ]
                            else ...[
                              Text(
                                buttonText,
                                style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal),
                              ),
                              const Icon(Icons.skip_next,size: 17,color: Colors.white),
                            ]
                          ]
                        );
                      },
                      onPressed: () {
                        if(timeLeft==0){
                          BlocProvider.of<BannerAdBloc>(context).add(HideBannerAdEvent());
                        }
                        },
                      timeOutInSeconds: 5,
                    ),
                  ),
                ),
                 Positioned(
                    bottom: 60,
                    left: 10,
                    child: Container(
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child:  Row(
                            children:[
                            const Image(image: AssetImage("assets/icons/sponsored_icon.png"),
                                color: Colors.white,width: 20,height:20),
                              const SizedBox(width: 5),
                              Text("Sponsored".tr(context),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal
                                ),
                            )
                          ]
                        )
                    )
                 )
              ]
            ),
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
    _betterPlayerController.dispose();
    _playbackTimer?.cancel();
    _countDown?.cancel();
    super.dispose();
  }
}
