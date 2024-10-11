import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla_app/features/ads/Domain/Entities/banner_ad.dart';
import 'package:ukla_app/features/ads/Domain/usecases/get_banner_ad_by_id.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_event.dart';
import 'package:ukla_app/features/ads/Presentation/bloc/banner_ad_state.dart';
import '../../Domain/usecases/increment_views_count.dart';

class BannerAdBloc extends Bloc<BannerAdEvent,BannerAdState>{
  final GetBannerAdById getBannerAdById;
  final IncrementViewsCount incrementViewsCount;

  BannerAdBloc({
    required this.incrementViewsCount,
    required this.getBannerAdById,
  }):super(BannerAdLoadingState()){
    on<BannerAdEvent> ((event,emit) async{
      if(event is LoadBannerAdEvent){
        BannerAd bannerAd = await getBannerAdById(event.id);
        emit(BannerAdLoadedState(bannerAd));
      }
      if(event is HideBannerAdEvent){
        emit(HideBannerAd());
      }
      if(event is IncrementViewEvent){
        await incrementViewsCount(event.id);
      }
    });
  }
}