import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/helpers/my_responsive.dart';
import '../widget/custom_project.dart';
import '../widget/custom_video.dart';
import '../widget/home_header_screen.dart';
import '../widget/about_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey aboutKey = GlobalKey();

  void scrollToAbout() {
    final context = aboutKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            /// 🔥 Header
            HomeHeaderScreen(
              onAboutTap: scrollToAbout,
            ),
            SizedBox(height:  MyResponsive.height(value: 20)),

            /// 🎥 Video Section

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: AppVideoPlayer(
                      videoPath: 'assets/image/svg/play_one.mp4',
                      height: height * 1,
                    ),
                  ),

                  SizedBox(width:  MyResponsive.width(value: 20)),

                  Expanded(
                    child: AppVideoPlayer(
                      videoPath: 'assets/image/svg/play_two.mp4',
                      height: height * 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:  MyResponsive.height(value: 20)),


            AboutSection(
              key: aboutKey,
            ),

            const SizedBox(height: 600), // demo scroll space
            CustomProject()],
        ),
      ),
    );
  }
}



