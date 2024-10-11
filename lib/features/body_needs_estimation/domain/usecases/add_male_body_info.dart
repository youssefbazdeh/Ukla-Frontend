import 'package:dartz/dartz.dart';
import 'package:ukla_app/core/error/failures.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/repositories/body_info_repository.dart';

class AddMaleBodyInfo {
  
  final BodyInfoRepository repository;

  AddMaleBodyInfo({required this.repository}); 

  Future<Either<Failure,MaleBodyInfo>> call ({required MaleBodyInfo maleBodyInfo})async{
    return await repository.addMalebodyinfo(maleBodyInfo) ; 
  }
  
}
