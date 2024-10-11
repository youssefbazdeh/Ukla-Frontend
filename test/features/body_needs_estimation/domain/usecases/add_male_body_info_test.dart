
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/repositories/body_info_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/usecases/add_male_body_info.dart';

class MockBodyInfoRepository extends Mock implements BodyInfoRepository {}

void main() {
  MockBodyInfoRepository mockBodyInfoRepository = MockBodyInfoRepository();
  AddMaleBodyInfo usecase = AddMaleBodyInfo(repository: mockBodyInfoRepository);

  setUp(() {
    mockBodyInfoRepository = MockBodyInfoRepository();
    usecase = AddMaleBodyInfo(repository: mockBodyInfoRepository);
  });

  final maleBodyInfo = MaleBodyInfo(
      id: 0,
      age: 24,
      height: 175,
      weight: 69,
      calorieNeed: 3000,
      physicalActivityLevelA: 8,
      physicalActivityLevelB: 2,
      physicalActivityLevelC: 6,
      physicalActivityLevelD: 4,
      physicalActivityLevelE: 2,
      physicalActivityLevelF: 2
      // see how to convert int to float
      );

  test(
    'should post bodyinfo to repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockBodyInfoRepository.addMalebodyinfo(maleBodyInfo))
          .thenAnswer((_) async => Right(MaleBodyInfo()));

      // The "act" phase of tPhe test. Call the not-yet-existent method.
      final result = await usecase(maleBodyInfo: maleBodyInfo);
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(MaleBodyInfo()));
      // Verify that the method has been called on the Repository with the right entity
      verify(mockBodyInfoRepository.addMalebodyinfo(maleBodyInfo));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockBodyInfoRepository);
    },
  );
}
