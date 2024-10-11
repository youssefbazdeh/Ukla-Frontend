import '../../../../core/Presentation/resources/strings_manager.dart';
import '../../../../core/domain/api_Service.dart';

Future<bool> incrementIngredientAdViewCount(List<int> idsList) async {
  String queryString = idsList.map((id) => 'ids=$id').join('&');
  String? url = '${AppString.SERVER_IP}/ukla/ingredientAd/incrementView?$queryString';
  var res = await HttpService().post(url,"");
  if(res.statusCode == 200){
    return true;
  }
  else {
    return false;
  }
}