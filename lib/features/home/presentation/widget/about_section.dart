import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
      child: width > 900
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _textSection()),
          SizedBox(width: 50.w),
          Expanded(child: _visualSection()),
        ],
      )
          : Column(
        children: [
          _textSection(),
          SizedBox(height: 30.h),
          _visualSection(),
        ],
      ),
    );
  }

  Widget _textSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Our Company",
          style: AppTextStyles.regular24.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),

        SizedBox(height: 10.h),

        Text(
          "We deliver premium Electric Roller Shutters solutions that combine safety, automation, and modern engineering for homes and businesses.",
          style: AppTextStyles.regular14.copyWith(
            color: AppColors.baseGray,
            height: 1.6,
          ),
        ),

        SizedBox(height: 30.h),

        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            _infoCard("5+ Years Experience", Icons.workspace_premium),
            _infoCard("100+ Projects", Icons.apartment),
            _infoCard("24/7 Support", Icons.support_agent),
          ],
        ),
      ],
    );
  }


  Widget _infoCard(String text, IconData icon) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 30),
          SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.regular14.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _visualSection() {
    return Container(
      height: 320.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.15),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔥 Icon Badge
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.security,
                size: 50,
                color: AppColors.primaryColor,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Trusted & Secure Solutions",
              style: AppTextStyles.regular20.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "We build smart automation systems with high durability and modern design.",
              textAlign: TextAlign.center,
              style: AppTextStyles.regular12.copyWith(
                color: AppColors.baseGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}