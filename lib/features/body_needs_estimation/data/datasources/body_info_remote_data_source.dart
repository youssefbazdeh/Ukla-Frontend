import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';
import 'package:ukla_app/core/error/exceptions.dart';
import 'package:ukla_app/features/body_needs_estimation/data/models/female_body_info_model.dart';
import 'package:ukla_app/features/body_needs_estimation/data/models/male_body_info_model.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/female_body_info.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/male_body_info.dart';
import 'package:http/http.dart' as http;

abstract class BodyInfoRemoteDataSource {
  Future<MaleBodyInfoModel> addMaleBodyInfo(MaleBodyInfo maleBodyInfo);

  Future<FemaleBodyInfoModel> addFemaleBodyInfo(FemaleBodyInfo femaleBodyInfo);
}

class BodyInfoRemoteDataSourceImpl implements BodyInfoRemoteDataSource {
  final storage = const FlutterSecureStorage();
  final http.Client client;

  BodyInfoRemoteDataSourceImpl({required this.client});
  var serverIp = AppString.SERVER_IP;

  @override
  Future<FemaleBodyInfoModel> addFemaleBodyInfo(
      FemaleBodyInfo femaleBodyInfo) async {
    FemaleBodyInfoModel femaleBodyInfoModel = FemaleBodyInfoModel();

    femaleBodyInfoModel.age = femaleBodyInfo.age;
    femaleBodyInfoModel.height = femaleBodyInfo.height;
    femaleBodyInfoModel.weight = femaleBodyInfo.weight;
    femaleBodyInfoModel.physicalActivityLevelA =
        femaleBodyInfo.physicalActivityLevelA;
    femaleBodyInfoModel.physicalActivityLevelB =
        femaleBodyInfo.physicalActivityLevelB;
    femaleBodyInfoModel.physicalActivityLevelC =
        femaleBodyInfo.physicalActivityLevelC;
    femaleBodyInfoModel.physicalActivityLevelD =
        femaleBodyInfo.physicalActivityLevelD;
    femaleBodyInfoModel.physicalActivityLevelE =
        femaleBodyInfo.physicalActivityLevelE;

    final response = await client.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/nutrition/addfemalebodyinfos'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body:
            jsonEncode(femaleBodyInfoModel.toJson())); // to do add json incode
    if (response.statusCode == 200) {
      return FemaleBodyInfoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MaleBodyInfoModel> addMaleBodyInfo(MaleBodyInfo maleBodyInfo) async {
    MaleBodyInfoModel maleBodyInfoModel = MaleBodyInfoModel();

    maleBodyInfoModel.age = maleBodyInfo.age;
    maleBodyInfoModel.height = maleBodyInfo.height;
    maleBodyInfoModel.weight = maleBodyInfo.weight;
    maleBodyInfoModel.physicalActivityLevelA =
        maleBodyInfo.physicalActivityLevelA;
    maleBodyInfoModel.physicalActivityLevelB =
        maleBodyInfo.physicalActivityLevelB;
    maleBodyInfoModel.physicalActivityLevelC =
        maleBodyInfo.physicalActivityLevelC;
    maleBodyInfoModel.physicalActivityLevelD =
        maleBodyInfo.physicalActivityLevelD;
    maleBodyInfoModel.physicalActivityLevelE =
        maleBodyInfo.physicalActivityLevelE;
    maleBodyInfoModel.physicalActivityLevelF =
        maleBodyInfo.physicalActivityLevelF;

    final response = await client.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/nutrition/addmalebodyinfos'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
        body: jsonEncode(maleBodyInfoModel.toJson()));
    if (response.statusCode == 200) {
      return MaleBodyInfoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
