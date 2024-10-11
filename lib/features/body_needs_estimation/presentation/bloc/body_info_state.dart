part of 'body_info_bloc.dart';

abstract class BodyInfoState extends Equatable {
  const BodyInfoState();

  @override
  List<Object> get props => [];
}

class MaleEmpty extends BodyInfoState {}

class FemaleEmpty extends BodyInfoState {}

class Loading extends BodyInfoState {}

class MaleLoaded extends BodyInfoState {
  final MaleBodyInfo malebodyInfo;
  const MaleLoaded({required this.malebodyInfo}) : super();
}

class FemaleLoaded extends BodyInfoState {
  final FemaleBodyInfo femalebodyInfo;
  const FemaleLoaded({required this.femalebodyInfo}) : super();
}

class Error extends BodyInfoState {
  final String message;
  const Error({required this.message}) : super();
}
