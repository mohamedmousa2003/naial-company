import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String videoPath;
  final double height;
  final String id;
  final bool isActive;
  final VoidCallback onTap;

  const AppVideoPlayer({
    super.key,
    required this.videoPath,
    required this.height,
    required this.id,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  // Hover state (web only)
  bool _hovered = false;

  // Overlay animation
  late AnimationController _overlayAnim;
  late Animation<double> _overlayFade;

  @override
  void initState() {
    super.initState();

    _overlayAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0, // start visible
    );
    _overlayFade = CurvedAnimation(
      parent: _overlayAnim,
      curve: Curves.easeInOut,
    );

    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      // ✅ Flutter Web: استخدم asset بشكل صح
      _controller = kIsWeb
          ? VideoPlayerController.asset(widget.videoPath)
          : VideoPlayerController.asset(widget.videoPath);

      await _controller.initialize();

      if (!mounted) return;

      _controller.setLooping(true);
      _controller.setVolume(0);

      // Auto-play silent on web (allowed by browsers)
      await _controller.play();

      setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isInitialized) return;

    if (widget.isActive && !oldWidget.isActive) {
      // ✅ User activated this video
      _controller.setVolume(1);
      _controller.play();
      _overlayAnim.reverse(); // hide overlay
    } else if (!widget.isActive && oldWidget.isActive) {
      // ✅ User deactivated — reset cleanly for web
      _controller.setVolume(0);
      _controller.seekTo(Duration.zero).then((_) {
        if (mounted) _controller.play(); // keep playing silently
      });
      _overlayAnim.forward(); // show overlay
    }
  }

  @override
  void deactivate() {
    // ✅ مهم على الـ web — pause لما الـ widget يتشال من الـ tree
    if (_isInitialized) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _overlayAnim.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: _hasError
          ? _errorPlaceholder()
          : !_isInitialized
          ? _loadingPlaceholder()
          : _playerBody(),
    );
  }

  // ── Player Body ─────────────────────────────────────────────────────────────

  Widget _playerBody() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Video ──────────────────────────────────────────
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),

              // ── Dark gradient overlay ─────────────────────────
              FadeTransition(
                opacity: _overlayFade,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black45,
                      ],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Play button ────────────────────────────────────
              if (!widget.isActive)
                FadeTransition(
                  opacity: _overlayFade,
                  child: Center(
                    child: AnimatedScale(
                      scale: _hovered ? 1.12 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 34,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Active: sound ON badge ─────────────────────────
              if (widget.isActive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _soundBadge(),
                ),

              // ── Bottom: tap to mute hint ───────────────────────
              if (widget.isActive && _hovered)
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Tap to stop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sound Badge ─────────────────────────────────────────────────────────────

  Widget _soundBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.volume_up_rounded, color: Colors.white, size: 14),
          SizedBox(width: 5),
          Text(
            "Sound ON",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading Placeholder ─────────────────────────────────────────────────────

  Widget _loadingPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // ── Error Placeholder ───────────────────────────────────────────────────────

  Widget _errorPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_rounded,
                color: Colors.grey.shade400, size: 36),
            const SizedBox(height: 10),
            Text(
              "Video unavailable",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}