import 'package:equatable/equatable.dart';
import 'package:ukla_app/features/ads/Domain/Entities/banner_ad.dart';

abstract class BannerAdState extends Equatable{
  const BannerAdState();
  @override
  List<Object> get props => [];
}

class BannerAdLoadingState extends BannerAdState{}

class BannerAdLoadedState extends BannerAdState{
  final BannerAd bannerAd;
  const BannerAdLoadedState(this.bannerAd) : super ();

  @override
  List<Object> get props => [bannerAd];
}

class HideBannerAd extends BannerAdState{}