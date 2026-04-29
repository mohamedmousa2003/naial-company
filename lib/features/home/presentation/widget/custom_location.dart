import 'dart:ui_web' as ui;
import 'dart:ui' as ui_core;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_colors.dart';

// ─── Config ───────────────────────────────────────────────────────────────────

class LocationConfig {
  static const String mapEmbedUrl =
      'https://www.google.com/maps/embed?pb=YOUR_EMBED_URL_HERE';

  static const String mapsDirectUrl =
      'https://www.google.com/maps?q=30.146982,31.368113';

  static const String address    = 'Cairo, Egypt\nYour full address here';
  static const String workingHours = 'Sat – Thu: 9AM – 10PM\nFri: 2PM – 8PM';
  static const String companyName  = 'Naial Shutter';
}



// ─── Breakpoints ──────────────────────────────────────────────────────────────

enum _Bp { xs, sm, md, lg, xl }

_Bp _bp(double w) {
  if (w < 480)  return _Bp.xs;
  if (w < 768)  return _Bp.sm;
  if (w < 1024) return _Bp.md;
  if (w < 1280) return _Bp.lg;
  return _Bp.xl;
}

// ─── Location Section ─────────────────────────────────────────────────────────

class LocationSection extends StatefulWidget {
  const LocationSection({super.key});

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection>
    with TickerProviderStateMixin {

  late AnimationController _entryCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;
  late Animation<double>   _pulseAnim;

  static const _viewId = 'map-pro-v1';
  bool _mapRegistered  = false;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
    ));
    _pulseAnim = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _registerMap();
  }

  void _registerMap() {
    if (_mapRegistered) return;
    _mapRegistered = true;
    ui.platformViewRegistry.registerViewFactory(_viewId, (int id) {
      return html.IFrameElement()
        ..src = LocationConfig.mapEmbedUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true
        ..setAttribute('loading', 'lazy')
        ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade');
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w  = MediaQuery.of(context).size.width;
    final bp = _bp(w);

    final double hPad = switch (bp) {
      _Bp.xs => 20,
      _Bp.sm => 32,
      _Bp.md => 60,
      _Bp.lg => 88,
      _Bp.xl => 120,
    };
    final double vPad = bp == _Bp.xs ? 56 : 88;

    return Container(
      color: AppColors.bg,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(bp),
                SizedBox(height: bp == _Bp.xs ? 32 : 52),
                _buildBody(bp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(_Bp bp) {
    final isXs = bp == _Bp.xs;
    final titleSize = switch (bp) {
      _Bp.xs => 24.0,
      _Bp.sm => 30.0,
      _Bp.md => 36.0,
      _Bp.lg => 42.0,
      _Bp.xl => 46.0,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow pill
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.accentMid),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(_pulseAnim.value * 0.55),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'OUR LOCATION',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isXs ? 14 : 18),

        // Title
        Text(
          'Our Location',
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            height: 1.15,
            color: AppColors.text1,
          ),
        ),

        SizedBox(height: isXs ? 8 : 10),

        // Subtitle
        Text(
          'Visit us and experience the craft firsthand.',
          style: TextStyle(
            fontSize: isXs ? 13 : 15,
            color: AppColors.text2,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── Body: side-by-side on wide, stacked on mobile ─────────────────────────

  Widget _buildBody(_Bp bp) {
    final isWide = bp == _Bp.md || bp == _Bp.lg || bp == _Bp.xl;

    if (isWide) {
      // Info left (flex 4), Map right (flex 5)
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 4, child: _buildInfoPanel(bp)),
            const SizedBox(width: 24),
            // Expanded(flex: 5, child: _buildMapPanel(bp)),
          ],
        ),
      );
    }

    // Stacked
    return Column(
      children: [
        _buildInfoPanel(bp),
        const SizedBox(height: 20),
        _buildMapPanel(bp),
      ],
    );
  }

  // ── Info Panel ────────────────────────────────────────────────────────────

  Widget _buildInfoPanel(_Bp bp) {
    final isXs = bp == _Bp.xs;
    final pad  = isXs ? 22.0 : 32.0;

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1E3A5F),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Brand block ──────────────────────────────────────
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocationConfig.companyName,
                    style: TextStyle(
                      fontSize: isXs ? 15 : 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text1,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Text(
                    'Photography Studio',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),
          _divider(),
          const SizedBox(height: 24),

          // ── Address ──────────────────────────────────────────
          _InfoRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.red,
            iconBg: AppColors.redSoft,
            label: 'Address',
            value: LocationConfig.address,
            isXs: isXs,
          ),

          const SizedBox(height: 20),
          _divider(),
          const SizedBox(height: 20),

          // ── Working Hours ─────────────────────────────────────
          _InfoRow(
            icon: Icons.access_time_rounded,
            iconColor: AppColors.amber,
            iconBg: AppColors.amberSoft,
            label: 'Working Hours',
            value: LocationConfig.workingHours,
            isXs: isXs,
          ),

          const SizedBox(height: 28),

          // ── CTA ───────────────────────────────────────────────
          _OpenMapsButton(isXs: isXs),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    height: 1,
    color: AppColors.divider,
  );

  // ── Map Panel ─────────────────────────────────────────────────────────────

  Widget _buildMapPanel(_Bp bp) {
    final isXs    = bp == _Bp.xs;
    final isSm    = bp == _Bp.sm;
    final isWide  = !isXs && !isSm;

    final double height = switch (bp) {
      _Bp.xs => 240,
      _Bp.sm => 300,
      _ => double.infinity, // stretches to match info panel height
    };

    final child = Container(
      height: isWide ? null : height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1E3A5F),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: isWide ? StackFit.expand : StackFit.loose,
        children: [
          // Map iframe
          if (isWide)
            const Positioned.fill(
              child: HtmlElementView(viewType: _viewId),
            )
          else
            SizedBox(
              height: height,
              child: const HtmlElementView(viewType: _viewId),
            ),

          // Top gradient overlay
          Positioned(
            top: 0, left: 0, right: 0,
            height: 64,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Studio badge overlay
          Positioned(
            top: 14, left: 14,
            child: _MapBadge(),
          ),

          // Bottom-right coordinates tag
          Positioned(
            bottom: 14, right: 14,
            child: _CoordBadge(),
          ),
        ],
      ),
    );

    return isWide ? Expanded(child: child) : child;
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;
  final String   label;
  final String   value;
  final bool     isXs;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.isXs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isXs ? 38 : 42,
          height: isXs ? 38 : 42,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: iconColor.withOpacity(0.18),
            ),
          ),
          child: Icon(icon, color: iconColor, size: isXs ? 17 : 19),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.text3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: isXs ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text1,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Map Badges ──────────────────────────────────────────────────────────────

class _MapBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui_core.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: Colors.white, size: 12),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Naial Shutter',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text1)),
                  Text('Photography Studio',
                      style: TextStyle(fontSize: 10, color: AppColors.text3)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoordBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ui_core.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
          ),
          child: const Text(
            '30.1470° N, 31.3681° E',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.text2,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Open Maps Button ────────────────────────────────────────────────────────

class _OpenMapsButton extends StatefulWidget {
  final bool isXs;
  const _OpenMapsButton({required this.isXs});

  @override
  State<_OpenMapsButton> createState() => _OpenMapsButtonState();
}

class _OpenMapsButtonState extends State<_OpenMapsButton> {
  bool _hovered = false;

  Future<void> _open() async {
    final uri = Uri.parse(LocationConfig.mapsDirectUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: widget.isXs ? 13 : 15),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF1447C0) : AppColors.accent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(_hovered ? 0.35 : 0.20),
                blurRadius: _hovered ? 24 : 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.near_me_rounded,
                  color: Colors.white, size: 17),
              const SizedBox(width: 9),
              Text(
                'Get Directions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.isXs ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform:
                Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}