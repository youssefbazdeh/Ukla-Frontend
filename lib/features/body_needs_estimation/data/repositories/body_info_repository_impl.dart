import 'package:ukla_app/core/error/exceptions.dart';
import 'package:ukla_app/features/body_needs_estimation/data/datasources/body_info_remote_data_source.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/repositories/body_info_repository.dart';

class BodyInfoRepositiryImpl implements BodyInfoRepository {
  final BodyInfoRemoteDataSource remoteDataSource;

  BodyInfoRepositiryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FemaleBodyInfo>> addFemalebodyinfo(
      FemaleBodyInfo femaleBodyInfo) async{
 
  try {
      final remoteFemaleBodyInfo =
          await remoteDataSource.addFemaleBodyInfo(femaleBodyInfo);
      FemaleBodyInfo recievedFemaleBodyInfo = FemaleBodyInfo();
      recievedFemaleBodyInfo.id = remoteFemaleBodyInfo.id;
      recievedFemaleBodyInfo.age = remoteFemaleBodyInfo.age;
      recievedFemaleBodyInfo.height = remoteFemaleBodyInfo.height;
      recievedFemaleBodyInfo.weight = remoteFemaleBodyInfo.weight;
      recievedFemaleBodyInfo.calorieNeed = remoteFemaleBodyInfo.calorieNeed;
      recievedFemaleBodyInfo.physicalActivityLevelA = remoteFemaleBodyInfo.physicalActivityLevelA; 
      recievedFemaleBodyInfo.physicalActivityLevelB = remoteFemaleBodyInfo.physicalActivityLevelB; 
      recievedFemaleBodyInfo.physicalActivityLevelC = remoteFemaleBodyInfo.physicalActivityLevelC; 
      recievedFemaleBodyInfo.physicalActivityLevelD = remoteFemaleBodyInfo.physicalActivityLevelD; 
      recievedFemaleBodyInfo.physicalActivityLevelE = remoteFemaleBodyInfo.physicalActivityLevelE;   
 
 

      return Right(recievedFemaleBodyInfo);
    } on ServerException {
      return Left(ServerFailure());
    }

  }

  @override
  Future<Either<Failure, MaleBodyInfo>> addMalebodyinfo(
      MaleBodyInfo maleBodyInfo) async {
    try {
      final remoteMaleBodyInfo =
          await remoteDataSource.addMaleBodyInfo(maleBodyInfo);
      MaleBodyInfo recievedMaleBodyInfo = MaleBodyInfo();
      recievedMaleBodyInfo.id = remoteMaleBodyInfo.id;
      recievedMaleBodyInfo.age = remoteMaleBodyInfo.age;
      recievedMaleBodyInfo.height = remoteMaleBodyInfo.height;
      recievedMaleBodyInfo.weight = remoteMaleBodyInfo.weight;
      recievedMaleBodyInfo.calorieNeed = remoteMaleBodyInfo.calorieNeed;
      recievedMaleBodyInfo.physicalActivityLevelA = remoteMaleBodyInfo.physicalActivityLevelA; 
      recievedMaleBodyInfo.physicalActivityLevelB = remoteMaleBodyInfo.physicalActivityLevelB; 
      recievedMaleBodyInfo.physicalActivityLevelC = remoteMaleBodyInfo.physicalActivityLevelC; 
      recievedMaleBodyInfo.physicalActivityLevelD = remoteMaleBodyInfo.physicalActivityLevelD; 
      recievedMaleBodyInfo.physicalActivityLevelE = remoteMaleBodyInfo.physicalActivityLevelE;   
      recievedMaleBodyInfo.physicalActivityLevelF = remoteMaleBodyInfo.physicalActivityLevelF;   
 

      return Right(recievedMaleBodyInfo);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
