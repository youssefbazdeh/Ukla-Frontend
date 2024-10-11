import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ukla_app/features/body_needs_estimation/data/models/male_body_info_model.dart';
import 'package:ukla_app/features/body_needs_estimation/data/datasources/body_info_remote_data_source.dart';
import 'package:ukla_app/features/body_needs_estimation/data/repositories/body_info_repository_impl.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';

class MockRemoteDataSource extends Mock implements BodyInfoRemoteDataSource {}

void main() {
  BodyInfoRepositiryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();

    repository = BodyInfoRepositiryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('addMaleBodyInfo', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests

    final maleBodyInfoModel = MaleBodyInfoModel(
        age: 24,
        height: 175.0,
        weight: 68.0,
        physicalActivityLevelA: 8.0,
        physicalActivityLevelB: 8.0,
        physicalActivityLevelC: 3.0,
        physicalActivityLevelD: 4.0,
        physicalActivityLevelE: 0.0,
        physicalActivityLevelF: 1.0);
    final MaleBodyInfo maleBodyInfo = MaleBodyInfo(
        age: 24,
        height: 175.0,
        weight: 68.0,
        physicalActivityLevelA: 8.0,
        physicalActivityLevelB: 8.0,
        physicalActivityLevelC: 3.0,
        physicalActivityLevelD: 4.0,
        physicalActivityLevelE: 0.0,
        physicalActivityLevelF: 1.0);

    mockRemoteDataSource = MockRemoteDataSource();

    repository = BodyInfoRepositiryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.addMaleBodyInfo(maleBodyInfo))
            .thenAnswer((_) async => maleBodyInfoModel);
        // act
        final result = await repository.addMalebodyinfo(maleBodyInfo);
        // assert
        verify(mockRemoteDataSource.addMaleBodyInfo(maleBodyInfo));
        expect(result, equals(Right(maleBodyInfo)));
      },
    );
  });
}
