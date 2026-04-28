import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/my_responsive.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/values/app_strings.dart';
import 'custom_contact.dart';

class HomeHeaderScreen extends StatefulWidget {
  final VoidCallback onAboutTap;

  const HomeHeaderScreen({
    super.key,
    required this.onAboutTap,
  });

  @override
  State<HomeHeaderScreen> createState() => _HomeHeaderScreenState();
}

class _HomeHeaderScreenState extends State<HomeHeaderScreen> {
  int selectedIndex = 0;
  bool showContactMenu = false;

  List<String> items = [
    AppStrings.home,
    AppStrings.about,
    AppStrings.project,
    AppStrings.contact,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MyResponsive.paddingAll(value: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.naialShutter,
                  style: AppTextStyles.regular24.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.bold)),
              Text(
                AppStrings.spacesLikeHome,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.baseGray,
                ),
              ),
            ],
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: List.generate(items.length, (index) {
                  return Padding(
                    padding: MyResponsive.paddingSymmetric(horizontal: 10),
                    child: _textClick(
                      text: items[index],
                      isSelected: selectedIndex == index,
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;

                          if (items[index] == AppStrings.about) {
                            widget.onAboutTap();
                          }

                          if (items[index] == AppStrings.contact) {
                            showContactMenu = !showContactMenu;
                          } else {
                            showContactMenu = false;
                          }
                        });
                      },
                    ),
                  );
                }),
              ),

              if (showContactMenu) const CustomContact(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textClick({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: MyResponsive.paddingSymmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppColors.primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.regular16.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.baseGray,
          ),
        ),
      ),
    );
  }
}