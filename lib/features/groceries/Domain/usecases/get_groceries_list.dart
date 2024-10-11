import 'package:ukla_app/features/groceries/Domain/Entities/grocery_list.dart';

import '../repositories/grocery_repository.dart';

class GetGroceriesList {
  final GroceryRepository groceryRepository;
  GetGroceriesList({required this.groceryRepository});

  Future<GroceryList> call(String languageCode) async {
    return await groceryRepository.getGroceryList(languageCode);
  }
}