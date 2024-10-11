part of 'body_info_bloc.dart';

abstract class BodyInfoEvent extends Equatable {
  const BodyInfoEvent();

  @override
  List<Object> get props => [];
}

class AddMaleBodyInfoEvent extends BodyInfoEvent {
  final MaleBodyInfo maleBodyInfo;

  const AddMaleBodyInfoEvent( this.maleBodyInfo);
}

class AddFemaleBodyInfoEvent extends BodyInfoEvent {
  final FemaleBodyInfo femaleBodyInfo;

  const AddFemaleBodyInfoEvent(this.femaleBodyInfo);
}


class MaleOrFemaleEvent extends BodyInfoEvent {
   final String sex;

   const MaleOrFemaleEvent({required this.sex});
 
}
