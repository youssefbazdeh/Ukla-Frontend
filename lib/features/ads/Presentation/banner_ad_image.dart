import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_button/timer_button.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/components/custom_circular_progress_indicator.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_bloc.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_event.dart';
import '../Data/banner_ad_service.dart';

class BannerAdImageWidget extends StatefulWidget {
  final int bannerAdImageId;
  final int bannerAdId;
  const BannerAdImageWidget({Key? key, required this.bannerAdImageId, required this.bannerAdId})
      : super(key: key);

  @override
  State<BannerAdImageWidget> createState() => _BannerAdImageWidgetState();
}

class _BannerAdImageWidgetState extends State<BannerAdImageWidget> {
  late Future<Uint8List> getImage;
  Timer? _timer;
  Timer? _countDown;
  late int timeLeft;

  @override
  void initState() {
    super.initState();
    getImage = getBannerAddImage(widget.bannerAdImageId);
    timeLeft=5;
    _timer = Timer(const Duration(seconds: 10), () {
      BlocProvider.of<BannerAdBloc>(context).add(HideBannerAdEvent());
      _timer?.cancel();
    });
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

  @override
  void dispose() {
    _timer?.cancel();
    _countDown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            BlocProvider.of<BannerAdBloc>(context).add(IncrementViewEvent(widget.bannerAdId));
            _startCountdown();
            Uint8List imageBytes = snapshot.data as Uint8List;
            return Stack(
              alignment: Alignment.center,
              children: [
                Image.memory(imageBytes, fit: BoxFit.cover),
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
                        child: Row(
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
              ],
            );
          }
          return const Center(
            child: SizedBox(
                width: 30,
                height: 30,
                child: CustomCircularProgressIndicator()
            ),
          );
        }));
  }
}
