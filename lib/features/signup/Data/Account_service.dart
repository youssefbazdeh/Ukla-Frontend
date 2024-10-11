import 'package:http/http.dart' as http;
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';


class SignupService {
  /* checkCode future */
  static Future<String> checkCodeActivation(String code1) async {
    final res = await http.get(Uri.parse(
        '${AppString.SERVER_IP}/ukla/registration/confirm?token=$code1'));

    return (res.body);
  }

  /* checkCode future */
  static Future<int> resendActivationCode(String email) async {
    final res = await http.post(
        Uri.parse('${AppString.SERVER_IP}/ukla/registration/resend/$email'));
  

    return (res.statusCode);
  }
}
