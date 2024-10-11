import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';

import '../../main.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  final NavigationService _navigationService = locator<NavigationService>();

  late String _accessToken;

  factory HttpService() {
    return _instance;
  }

  HttpService._internal();

  static Future<String> refreshToken() async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: 'refresh_token');

    final response = await http.get(
      Uri.parse('${AppString.SERVER_IP}/ukla/registration/refreshtoken'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> tokens = json.decode(response.body);
      await storage.write(key: 'jwt', value: tokens['access_token']);
      await storage.write(key: 'refresh_token', value: tokens['refresh_token']);
      return tokens['access_token'];
    }
    throw Exception('Refresh token failed.');
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  Future<Map<String, String>> _getHeaders() async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    if (jwt == null) {
      return {
        'Content-Type': 'application/json',
      };
    }
    setAccessToken(jwt);
    return {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> get(String url) async {
    return _performRequest(
        () async => http.get(Uri.parse(url), headers: await _getHeaders()));
  }
  Future<http.Response> example(String url) async {
    return _performRequest(
        () async => http.get(Uri.parse(url), headers: await _getHeaders()));
  }

  Future<http.Response> put(String url, var body) async {
    return _performRequest(() async => http.put(Uri.parse(url),
        body: jsonEncode(body), headers: await _getHeaders()));
  }

  Future<http.Response> post(String url, String body) async {
    return _performRequest(() async => http.post(
          Uri.parse(url),
          body: body,
          headers: await _getHeaders(),
        ));
  }
  Future<http.Response> postWithoutToken(String url, String body) async {
    return _performRequest(() async => http.post(
          Uri.parse(url),
          body: body,
        ));
  }

  Future<http.Response> delete(String url) async {
    return _performRequest(
        () async => http.delete(Uri.parse(url), headers: await _getHeaders()));
  }

  Future<T> _performRequest<T>(Future<T> Function() request,
      {Duration timeoutDuration = const Duration(seconds: 10)}) async {
    try {
      final response = await request().timeout(timeoutDuration);
      if (response is http.BaseResponse && response.statusCode == 401 && isTokenExpired(_accessToken)) {
        try {
          final newToken = await refreshToken();
          setAccessToken(newToken);
          final refreshedResponse = await request().timeout(timeoutDuration);
          return refreshedResponse;
        } catch (e) {
          await clearTokens();
          navigateToLoginScreen();
          throw Exception('Refresh token failed.');
        }
      } else if (response is http.BaseResponse &&
          response.statusCode == 410 &&
          !isTokenExpired(_accessToken)) {
        showDialog(
          context: _navigationService.navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text('title'.tr(context)),
                content: Text('message'.tr(context)),
                actions: <Widget>[
                  TextButton(
                    child: Text("button".tr(context)),
                    onPressed: () {
                      clearTokens();
                      navigateToLoginScreen();
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else if (response is http.BaseResponse && response.statusCode == 500) {
        _navigationService
            .showErrorSnackBar("An error occurred, try again later");
      } else if (response is http.BaseResponse && response.statusCode == 409) {
        _navigationService.showErrorSnackBar(response is http.Response ? response.body : response.reasonPhrase ?? 'Error');
      }
      return response;
    } on TimeoutException catch (_) {
      throw TimeoutException("Request timed out");
    }
  }

  bool isTokenExpired(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final expirationTime = decodedToken['exp'];
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return currentTime > expirationTime;
    } catch (e) {
      return true;
    }
  }

  Future<void> clearTokens() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'refresh_token');
  }

  void navigateToLoginScreen() {
    _navigationService.navigateTo('/login');
  }
}
