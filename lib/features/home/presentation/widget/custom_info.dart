import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectModel {
  final String title;
  final String description;
  final String image;
  final String liveUrl;
  final String githubUrl;

  ProjectModel({
    required this.title,
    required this.description,
    required this.image,
    required this.liveUrl,
    required this.githubUrl,
  });
}

/// ================= SAMPLE DATA =================
final List<ProjectModel> projects = [
  ProjectModel(
    title: "Flutter E-Commerce App",
    description: "Full e-commerce app with clean architecture & API integration.",
    image: "assets/images/p1.png",
    liveUrl: "https://flutter.dev",
    githubUrl: "https://github.com",
  ),
  ProjectModel(
    title: "Portfolio Website",
    description: "Modern portfolio built with Flutter Web.",
    image: "assets/images/p2.png",
    liveUrl: "https://flutter.dev",
    githubUrl: "https://github.com",
  ),
  ProjectModel(
    title: "Chat App",
    description: "Real-time chat app using Firebase.",
    image: "assets/images/p3.png",
    liveUrl: "https://flutter.dev",
    githubUrl: "https://github.com",
  ),
];

/// ================= MAIN WIDGET =================
class CustomProject extends StatelessWidget {
  const CustomProject({super.key});

  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 80.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "My Projects",
            style: TextStyle(
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),


        ],
      ),
    );
  }
}
