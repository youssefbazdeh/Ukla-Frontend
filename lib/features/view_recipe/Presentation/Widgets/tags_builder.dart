import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ukla_app/features/view_recipe/Domain/Entities/tag.dart';

Widget tagsBuilder(List<Tag> tags, String languageCode) {
  return Wrap(
      children: tags
          .map((tag) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(translateTagTitle(tag.title!, languageCode),
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF8A8A8A)))))
          .toList());
}

String translateTagTitle(String title, String languageCode) {
  if (tagTitleTranslations.containsKey(title)) {
    if (tagTitleTranslations[title]!.containsKey(languageCode)) {
      return tagTitleTranslations[title]![languageCode]!;
    }
  }
  return title;
}

Map<String, Map<String, String>> tagTitleTranslations = {
  'Breakfast': {
    'en': 'Breakfast',
    'fr': 'Petit déjeuner',
    'ar': 'فطور',
  },
  'Lunch': {
    'en': 'Lunch',
    'fr': 'Déjeuner',
    'ar': 'غداء',
  },
  'Dinner': {
    'en': 'Dinner',
    'fr': 'Dîner',
    'ar': 'عشاء',
  },
  'Main course': {
    'en': 'Main course',
    'fr': 'Plat principal',
    'ar': 'طبق رئيسي',
  },
  'Soup': {
    'en': 'Soup',
    'fr': 'Soupe',
    'ar': 'حساء',
  },
  'Drink': {
    'en': 'Drink',
    'fr': 'Boisson',
    'ar': 'مشروب',
  },
  'Dessert': {
    'en': 'Dessert',
    'fr': 'dessert',
    'ar': 'تحلية',
  },
  'Salad': {
    'en': 'Salad',
    'fr': 'Salade',
    'ar': 'سلطة',
  },
  'Entree': {
    'en': 'Entree',
    'fr': 'Entree',
    'ar': 'الطبق الأول',
  },
  'Side dish': {
    'en': 'Side dish',
    'fr': 'accompagnement',
    'ar': 'طبق جانبي',
  },
  'Snack': {
    'en': 'Snack',
    'fr': 'Goûter',
    'ar': 'وجبة خفيفة',
  },
  'Appetiser': {
    'en': 'Appetiser',
    'fr': "HORS D'OEUVRES",
    'ar': 'مقبلات'
  }
};
