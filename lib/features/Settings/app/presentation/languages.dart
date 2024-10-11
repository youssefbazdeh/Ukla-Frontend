import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/features/Settings/settings_interface.dart';

import '../../../../main.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  String currentAppLanguageCode = 'en';
  String currentContentLanguageCode = 'en';

  final List<String> languages = [
    'English',
    'Francais',
    'عربي',
  ];


  @override
  void initState() {
    super.initState();
    Provider.of<LanguageProvider>(context, listen: false).loadLanguageCode();
    _loadCurrentAppLanguageCode();
    _loadCurrentContentLanguageCode();
  }

  Future<void> saveLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    Provider.of<SelectedContentLanguage>(context, listen: false).locale = Locale(languageCode);
    Provider.of<LanguageProvider>(context, listen: false).setLanguageCode(languageCode);
    setState(() {});
  }

  Future<void> saveContentLanguageCode(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('contentLanguageCode', languageCode);
  Provider.of<SelectedContentLanguage>(context,listen: false).setContentLanguageCode(languageCode);
  setState(() {});
  }

  Future<void> _loadCurrentAppLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentAppLanguageCode = prefs.getString('languageCode') ?? 'en';
    });
  }


  Future<void> _loadCurrentContentLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentContentLanguageCode = prefs.getString('contentLanguageCode') ?? 'en';
    });
  }



  @override
  Widget build(BuildContext context) {
    double width = getDimensions(context)[1];
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 23, left: 10),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Ionicons.arrow_back)),
                      const SizedBox(width: 15),
                      Text("Language".tr(context),
                          style: TextStyle(
                              fontSize: width < 600 ? 24.sp : 30.sp,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
              ExpansionTile(
                title: Text("App Language".tr(context)),
                children: languages.map((language) {
                  final isSelected = getLanguageCode(language) == currentAppLanguageCode;
                  return ListTile(
                    title: Text(
                      language,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    onTap: () {
                      String languageCode = getLanguageCode(language);
                      saveLanguageCode(languageCode);
                      final snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Builder(
                          builder: (BuildContext context) {
                            return Text(
                              "Selected app language".tr(context),
                              style:  TextStyle(fontSize: 16.sp),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              ExpansionTile(
                title: Text("Content Language".tr(context)),
                children: languages.map((language) {
                  final isSelected = getLanguageCode(language) == currentContentLanguageCode;
                  return ListTile(
                    title: Text(
                      language,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    onTap: () {
                      String languageCode = getLanguageCode(language);
                      saveContentLanguageCode(languageCode);
                      final snackBar = SnackBar(
                        backgroundColor: const Color(0XFFFA6375),
                        content: Builder(
                          builder: (BuildContext context) {
                            // Determine the message based on the selected languageCode
                            String message;
                            switch (languageCode) {
                              case 'en':
                                message = "Selected English as content language";
                                break;
                              case 'fr':
                                message = "Français sélectionné comme langue de contenu";
                                break;
                              case 'ar':
                                message = "تم تحديد العربية كلغة المحتوى";
                                break;
                              default:
                                message = "Selected English as content language";
                            }
                            return Text(
                              message,
                              style:  TextStyle(fontSize: 16.sp),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    },


                  );
                }).toList(),
              ),
            ],
          ),
        )
    );
  }


  String getLanguageCode(String languageName) {
    switch (languageName) {
      case 'English':
        return 'en';
      case 'Francais':
        return 'fr';
      case 'عربي':
        return 'ar';
      default:
        return 'en';
    }
  }
}
