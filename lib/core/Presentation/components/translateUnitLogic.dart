
String translateUnit(String unit, String languageCode) {
  if (unitTranslations.containsKey(unit)) {
    if (unitTranslations[unit]!.containsKey(languageCode)) {
      return unitTranslations[unit]![languageCode]!;
    }
  }
  return unit;
}

Map<String, Map<String, String>> unitTranslations = {
  'g': {
    'en': 'g',
    'fr': 'g',
    'ar': 'غ',
  },
  'ml': {
    'en': 'ml',
    'fr': 'ml',
    'ar': 'مل',
  },
  'Kg': {
    'en': 'kg',
    'fr': 'kg',
    'ar': 'كغ',
  },
  'cup': {
    'en': 'cup',
    'fr': 'tasse',
    'ar': 'كوب',
  },
  'tsp': {
    'en': 'tsp',
    'fr': 'càc',
    'ar': 'ملعقة صغيرة',
  },
  'tbsp': {
    'en': 'tbsp',
    'fr': 'cs',
    'ar': 'ملعقة كبيرة',
  },
  'L': {
    'en': 'L',
    'fr': 'L',
    'ar': 'ل',
  },
  'slice': {
    'en': 'slice',
    'fr': 'tranche',
    'ar': 'شريحة',
  },
  'clove': {
    'en': 'clove',
    'fr': 'gousse',
    'ar': 'فص',
  },
  'small': {
    'en': 'small',
    'fr': 'petit',
    'ar': 'صغير',
  },
  'medium': {
    'en': 'medium',
    'fr': 'moyen',
    'ar': 'متوسط',
  },
  'large': {
    'en': 'large',
    'fr': 'grand',
    'ar': 'كبير',
  },
  'cl': {
    'en': 'cl',
    'fr': 'cl',
    'ar': 'صل ',
  }
};