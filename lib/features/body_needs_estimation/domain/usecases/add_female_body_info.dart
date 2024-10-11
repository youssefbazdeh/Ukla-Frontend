import 'package:dartz/dartz.dart';
import 'package:ukla_app/core/error/failures.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/repositories/body_info_repository.dart';

class AddFemaleBodyInfo {
  final BodyInfoRepository repository;
  AddFemaleBodyInfo({required this.repository});
  
   Future<Either<Failure,FemaleBodyInfo>> call ({required FemaleBodyInfo femaleBodyInfo})async{
    return await repository.addFemalebodyinfo(femaleBodyInfo) ; 
  }
  
}
