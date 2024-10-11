import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ukla_app/features/body_needs_estimation/data/models/male_body_info_model.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';

import '../../../../fixtures/fixture.reader.dart';

void main() {
  final maleBodyInfoModel = MaleBodyInfoModel(
      id: 35,
      age: 24,
      height: 175.0,
      weight: 68.0,
      calorieNeed: 3121,
      physicalActivityLevelA: 8.0,
      physicalActivityLevelB: 8.0,
      physicalActivityLevelC: 3.0,
      physicalActivityLevelD: 4.0,
      physicalActivityLevelE: 0.0,
      physicalActivityLevelF: 1.0
      // see how to convert int to float ?
      );

  test(
    'should be a subclass of MaleBodyInfo entity',
    () async {
      // assert
      expect(maleBodyInfoModel, isA<MaleBodyInfo>());
    },
  );

  group('fromJson', () {
    // test not working to check if methode actually works
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('MaleBodyInfo.json'));
        // act
        final result = MaleBodyInfoModel.fromJson(jsonMap);
        // assert
        expect(result, maleBodyInfoModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = maleBodyInfoModel.toJson();
        // assert
        final expectedJsonMap = {
          "height": 175.0,
          "weight": 68.0,
          "age": 24,
          "physicalActivityLevelA": 8.0,
          "physicalActivityLevelB": 8.0,
          "physicalActivityLevelC": 3.0,
          "physicalActivityLevelD": 4.0,
          "physicalActivityLevelE": 0.0,
          "calorieNeed": 3121,
          "id": 35,
          "physicalActivityLevelF": 1.0
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
