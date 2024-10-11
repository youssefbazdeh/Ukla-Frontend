import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage(); 
  Future<String?> getjwt() {

    return storage.read(key: 'jwt');
  }