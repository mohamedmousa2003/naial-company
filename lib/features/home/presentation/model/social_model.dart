import '../../../../core/utils/app_assets.dart';
import '../../../../core/values/app_strings.dart';

class SocialModel {
  final String title;
  final String url;
  final String icon;

  SocialModel({required this.title, required this.url, required this.icon});
}

final List<SocialModel> socialList = [
  SocialModel(
    title: AppStrings.whatsApp,
    url: "https://wa.me/201067379625",
    icon: AppAssets.whatsApp,
  ),
  SocialModel(
    title: AppStrings.facebook,
    url: "https://www.facebook.com/share/14aHN5v9yXp/?mibextid=wwXIfr",
    icon: AppAssets.facebook,
  ),
  SocialModel(
    title: AppStrings.instagram,
    url: "https://www.instagram.com/shutter_5553?igsh=ODRheWdmdnk2MGJ4",
    icon: AppAssets.instagram,
  ),
];
