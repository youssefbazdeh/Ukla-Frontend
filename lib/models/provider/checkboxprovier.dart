import 'package:flutter/material.dart';

class CheckProvider extends ChangeNotifier {
  List<bool> recipeschecked = [];

  initiatList(bool b, int l) {
    for (int i = 0; i < l; i++) {
      recipeschecked[i] = b;
    }
  }

  checkitem(int index) {
    recipeschecked[index] = true;
    notifyListeners();
  }

  List<bool> geListofcheckedrecipes() {
    return recipeschecked;
  }
}
