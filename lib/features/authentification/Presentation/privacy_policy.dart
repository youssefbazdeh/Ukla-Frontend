import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy".tr(context)),
        backgroundColor: AppColors.buttonTextColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy".tr(context),
              style:  TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "PrivacyPolicyDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "CollectionUsePersonalInfo".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "CollectPersonalInfo".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "SharePersonalInfo".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "ConfidentialInfo".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "DataSecurity".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "DataSecurityDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'UserRights'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'UserRightsDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact us'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact usDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'PrivacyPolicy"'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'PrivacyPolicyUpdate'.tr(context),
              style:  TextStyle(
                fontSize: 14.sp,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
