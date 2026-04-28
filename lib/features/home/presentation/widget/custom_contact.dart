import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/helpers/my_responsive.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../model/social_model.dart';

class CustomContact extends StatelessWidget {
  const CustomContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyResponsive.paddingSymmetric(vertical: 20,horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.baseWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.baseGray,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: socialList.map((item) {
          return _socialItem(
            icon: item.icon,
            text: item.title,
            url: item.url,
          );
        }).toList(),
      ),
    );
  }

  Widget _socialItem({
    required String icon,
    required String text,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: MyResponsive.paddingSymmetric(vertical: 15,horizontal: 8),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 30.w,
              height: 30.h,
            ),
            SizedBox(width: MyResponsive.width(value: 15)),
            Text(
              text,
              style: AppTextStyles.regular14.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}