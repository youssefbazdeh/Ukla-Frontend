import 'package:ukla_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';

abstract class BodyInfoRepository {
  Future<Either<Failure, MaleBodyInfo>> addMalebodyinfo(MaleBodyInfo maleBodyInfo);
  Future<Either<Failure, FemaleBodyInfo>> addFemalebodyinfo(FemaleBodyInfo femaleBodyInfo);
}
