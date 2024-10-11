import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/ads/Presentation/Banner_ad_video_player.dart';
import 'package:ukla_app/features/ads/Presentation/banner_ad_image.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_bloc.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_event.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_state.dart';
import 'package:ukla_app/features/view_recipe/Domain/chewie_player.dart';
import '../../../core/Presentation/components/custom_circular_progress_indicator.dart';
import '../../../injection_container.dart';

class BannerAdCustomWidget extends StatefulWidget {
  final String? videoUrl;
  final int? id;
  final double? height;
  final bool shouldShow;
  const BannerAdCustomWidget({Key? key, this.videoUrl, this.id, this.height, required this.shouldShow}) : super(key: key);

  @override
  State<BannerAdCustomWidget> createState() => _BannerAdCustomWidgetState();
}

class _BannerAdCustomWidgetState extends State<BannerAdCustomWidget> {
  final BannerAdBloc bloc = sl<BannerAdBloc>();
  List<int> idsList = [];

  @override
  void initState(){
    super.initState();
    loadAndUpdateBannerAdIds();
  }

  Future<void> loadAndUpdateBannerAdIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bannerAdIds = prefs.getStringList('banner_ad_list');
    if (bannerAdIds!= null && bannerAdIds.isNotEmpty) {
      for (var item in bannerAdIds) {
        idsList.add(int.parse(item));
      }
      idsList.insert(0, idsList.removeLast());
      await prefs.setStringList('banner_ad_list', idsList.map((e) => e.toString()).toList());
      if (idsList.isNotEmpty) {
        bloc.add(LoadBannerAdEvent(idsList[0]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: bloc,
      child: BlocBuilder<BannerAdBloc,BannerAdState>(
        builder: (context,state){
          if(state is BannerAdLoadedState){
            if(widget.shouldShow){
              if(state.bannerAd.video != null){
                return BannerAdVideoPlayerWidget(videoUrl: state.bannerAd.video!.sasUrl!,bannerId: state.bannerAd.id);
              }else{
                return BannerAdImageWidget(bannerAdImageId: state.bannerAd.image!.id,bannerAdId: state.bannerAd.id);
              }
            }else{
              if(widget.videoUrl!=null){
                return ChewiVideoAsset(videoUrl: widget.videoUrl!,recipeId: widget.id);
              }else{
                SizedBox(
                  height: widget.height! / 3,
                  child:Center(
                      child: Text(
                          "This step has no video".tr(context),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          )
                      )
                  ),
                );
              }
            }
          }else if(state is HideBannerAd){
            if(widget.videoUrl!=null){
              return ChewiVideoAsset(videoUrl: widget.videoUrl!,recipeId: widget.id);
            }else{
              SizedBox(
                height: widget.height! / 3,
                child:Center(
                    child: Text(
                        "This step has no video".tr(context),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        )
                    )
                ),
              );
            }
          }
          return const Center(
            child: SizedBox(
                width: 30,
                height: 30,
                child: CustomCircularProgressIndicator()
            ),
          );
        },
      ),
    );
  }
}
