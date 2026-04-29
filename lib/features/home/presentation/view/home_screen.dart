import 'package:flutter/material.dart';
import '../widget/custom_info.dart';
import '../widget/custom_location.dart';
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
  final GlobalKey projectKey = GlobalKey();
  final GlobalKey locationKey = GlobalKey();

  String? activeVideoId;

  void scrollToAbout() {
    final ctx = aboutKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }void scrollToLocation() {
    final ctx = locationKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToProject() {
    final ctx = projectKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleVideo(String id) {
    setState(() {
      activeVideoId = activeVideoId == id ? null : id;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isMobile = width < 650;
    final isTablet = width >= 650 && width < 1050;

    // Video height responsive
    final videoHeight = isMobile
        ? size.height * 0.28
        : isTablet
        ? size.height * 0.38
        : size.height * 0.55;

    // Horizontal padding responsive
    final hPad = isMobile ? 16.0 : isTablet ? 28.0 : 48.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SelectionArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────
              HomeHeaderScreen(
                onAboutTap: scrollToAbout,
                onProjectTap: scrollToProject,
                onLocationTap: scrollToLocation,
              ),

              const SizedBox(height: 32),

              // ── First Video Row (2 videos) ───────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: isMobile
                    ? _videoColumn(
                  ids: ["video1", "video2"],
                  paths: [
                    'assets/image/svg/play_one.mp4',
                    'assets/image/svg/play_two.mp4',
                  ],
                  height: videoHeight,
                )
                    : _videoRow(
                  ids: ["video1", "video2"],
                  paths: [
                    'assets/image/svg/play_one.mp4',
                    'assets/image/svg/play_two.mp4',
                  ],
                  height: videoHeight,
                  gap: 16,
                ),
              ),

              const SizedBox(height: 32),

              LocationSection(
                key: locationKey,
              ),


              const SizedBox(height: 48),

              // ── Projects ─────────────────────────────────────────
              CustomProject(key: projectKey),

              const SizedBox(height: 48),

              // ── Second Video Row (3 videos) ───────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: isMobile
                    ? _videoColumn(
                  ids: ["video3", "video4", "video5"],
                  paths: [
                    'assets/image/svg/play_three.mp4',
                    'assets/image/svg/play_four.mp4',
                    'assets/image/svg/play_five.mp4',
                  ],
                  height: videoHeight,
                )
                    : _videoRow(
                  ids: ["video3", "video4", "video5"],
                  paths: [
                    'assets/image/svg/play_three.mp4',
                    'assets/image/svg/play_four.mp4',
                    'assets/image/svg/play_five.mp4',
                  ],
                  height: isMobile
                      ? videoHeight
                      : isTablet
                      ? videoHeight * 0.85
                      : videoHeight * 0.75,
                  gap: 16,
                ),
              ),

              const SizedBox(height: 48),
              // ── About Section ────────────────────────────────────
              AboutSection(key: aboutKey),
              const SizedBox(height: 48),

              // ── Contact ──────────────────────────────────────────
              const ContactSection(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _videoRow({
    required List<String> ids,
    required List<String> paths,
    required double height,
    required double gap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(ids.length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < ids.length - 1 ? gap : 0),
            child: AppVideoPlayer(
              key: ValueKey(ids[i]),
              id: ids[i],
              videoPath: paths[i],
              height: height,
              isActive: activeVideoId == ids[i],
              onTap: () => toggleVideo(ids[i]),
            ),
          ),
        );
      }),
    );
  }

  Widget _videoColumn({
    required List<String> ids,
    required List<String> paths,
    required double height,
  }) {
    return Column(
      children: List.generate(ids.length, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < ids.length - 1 ? 16 : 0),
          child: AppVideoPlayer(
            key: ValueKey(ids[i]),
            id: ids[i],
            videoPath: paths[i],
            height: height,
            isActive: activeVideoId == ids[i],
            onTap: () => toggleVideo(ids[i]),
          ),
        );
      }),
    );
  }
}