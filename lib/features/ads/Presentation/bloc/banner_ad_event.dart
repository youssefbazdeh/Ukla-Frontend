import 'package:equatable/equatable.dart';

abstract class BannerAdEvent extends Equatable{
  const BannerAdEvent();

  @override
  List<Object> get props => [];
}

class LoadBannerAdEvent extends BannerAdEvent{
  final int id;
  const LoadBannerAdEvent(this.id);
}

class HideBannerAdEvent extends BannerAdEvent{}

class IncrementViewEvent extends BannerAdEvent{
  final int id;
  const IncrementViewEvent(this.id);
}