import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/usecases/add_female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/usecases/add_male_body_info.dart';

part 'body_info_event.dart';
part 'body_info_state.dart';

class BodyInfoBloc extends Bloc<BodyInfoEvent, BodyInfoState> {
  final AddMaleBodyInfo addMaleBodyInfo;
  final AddFemaleBodyInfo addFemaleBodyInfo;

  BodyInfoBloc({required this.addMaleBodyInfo, required this.addFemaleBodyInfo})
      : super(FemaleEmpty()) {
    on<BodyInfoEvent>((event, emit) async {
      if (event is AddMaleBodyInfoEvent) {
        emit(Loading());
        final maleBodyInfoOrFailure =
            await addMaleBodyInfo(maleBodyInfo: event.maleBodyInfo);
        emit(maleBodyInfoOrFailure.fold(
            (failure) => const Error(message: "adding infos error"),
            (bodyinfo) => MaleLoaded(malebodyInfo: bodyinfo)));
      } else if (event is AddFemaleBodyInfoEvent) {
        emit(Loading());
        final femaleBodyInfoOrFailure =
            await addFemaleBodyInfo(femaleBodyInfo: event.femaleBodyInfo);
        emit(femaleBodyInfoOrFailure.fold(
            (failure) => const Error(message: "adding infos error"),
            (bodyinfo) => FemaleLoaded(femalebodyInfo: bodyinfo)));
      } else if (event is MaleOrFemaleEvent) {
        if (event.sex == "Male") {
          emit(MaleEmpty());
        }
        if (event.sex == "Female") {
          emit(FemaleEmpty());
        }

      
      }
    });
  }
}
