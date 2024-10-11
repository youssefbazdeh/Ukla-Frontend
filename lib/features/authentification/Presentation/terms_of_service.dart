import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms of Service".tr(context)),
        backgroundColor: AppColors.buttonTextColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms of Service".tr(context),
              style:  TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "TermsOfServiceIntroduction".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "UserAccounts".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "UserAccountsDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "AppFeatures".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "AppFeaturesDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "UserContent".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "UserContentDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "SecurityPrivacy".tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "SecurityPrivacyDescription".tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AdsRevenue'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AdsRevenueDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'AppModifications'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AppModificationsDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Termination'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'TerminationDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ObligationsRestrictions'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ObligationsRestrictionsDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'IntellectualProperty'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'IntellectualPropertyDescription'.tr(context),
              style:  TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Conclusion'.tr(context),
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ConclusionDescription'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'TermsLastReviewed'.tr(context),
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
