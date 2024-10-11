String translateDay(String day, String languageCode) {
  if (languageCode == 'ar') {
    Map<String, String> arabicDayNames = {
      'MONDAY': 'الاثنين',
      'TUESDAY': 'الثلاثاء',
      'WEDNESDAY': 'الأربعاء',
      'THURSDAY': 'الخميس',
      'FRIDAY': 'الجمعة',
      'SATURDAY': 'السبت',
      'SUNDAY': 'الأحد',
    };
    return arabicDayNames[day] ?? day;
  } else if (languageCode == 'fr'){
    Map<String, String> frenchDayNames = {
      'MONDAY': 'Lundi',
      'TUESDAY': 'Mardi',
      'WEDNESDAY': 'Mercredi',
      'THURSDAY': 'Jeudi',
      'FRIDAY': 'Vendredi',
      'SATURDAY': 'Samedi',
      'SUNDAY': 'Dimanche',
    };
    return frenchDayNames[day] ?? day;
  }
  return day;
}