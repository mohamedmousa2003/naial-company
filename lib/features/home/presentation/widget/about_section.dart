import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;
    final isTablet = width >= 650 && width < 1050;
    final isDesktop = width >= 1050;

    // Responsive padding
    final hPad = isMobile ? 20.0 : isTablet ? 40.0 : 80.0;
    final vPad = isMobile ? 44.0 : isTablet ? 60.0 : 80.0;

    return SelectionArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: isDesktop
                ? _desktopLayout()
                : _stackedLayout(isMobile, isTablet),
          ),
        ),
      ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 55, child: _textSection(false, false)),
        const SizedBox(width: 64),
        Expanded(flex: 45, child: _visualSection()),
      ],
    );
  }

  Widget _stackedLayout(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSection(isMobile, isTablet),
        SizedBox(height: isMobile ? 36 : 52),
        _visualSection(),
      ],
    );
  }

  // ─── Text Section ───────────────────────────────────────────────────────────

  Widget _textSection(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tagline(),
        SizedBox(height: isMobile ? 14 : 18),
        _headline(isMobile, isTablet),
        SizedBox(height: isMobile ? 14 : 18),
        _description(isMobile),
        SizedBox(height: isMobile ? 28 : 36),
        _statsRow(isMobile),
        SizedBox(height: isMobile ? 28 : 36),
        _featureList(isMobile),
      ],
    );
  }

  Widget _tagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "WHO WE ARE",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headline(bool isMobile, bool isTablet) {
    final size = isMobile ? 24.0 : isTablet ? 30.0 : 36.0;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w800,
          height: 1.18,
          letterSpacing: -0.5,
          color: const Color(0xFF1A1A2E),
        ),
        children: [
          const TextSpan(text: "Premium Shutter\n"),
          TextSpan(
            text: "Solutions ",
            style: TextStyle(color: AppColors.primaryColor),
          ),
          const TextSpan(text: "for Modern\nSpaces"),
        ],
      ),
    );
  }

  Widget _description(bool isMobile) {
    return Text(
      "We deliver Electric Roller Shutter systems that merge safety, "
          "smart automation, and precision engineering — built to last for "
          "homes and commercial spaces alike.",
      style: TextStyle(
        fontSize: isMobile ? 13 : 14,
        color: AppColors.baseGray,
        height: 1.78,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _statsRow(bool isMobile) {
    final stats = [
      ("5+", "Years Experience"),
      ("100+", "Projects Done"),
      ("99%", "Satisfaction"),
    ];
    return Wrap(
      spacing: isMobile ? 28.0 : 48.0,
      runSpacing: 20,
      children: stats.map((s) => _statItem(s.$1, s.$2, isMobile)).toList(),
    );
  }

  Widget _statItem(String value, String label, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.55),
            ],
          ).createShader(bounds),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 30.0 : 38.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 11 : 12,
            color: AppColors.baseGray,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _featureList(bool isMobile) {
    final features = [
      (Icons.bolt_rounded, "Smart automation & remote control"),
      (Icons.shield_rounded, "High-security locking systems"),
      (Icons.build_rounded, "24/7 maintenance & support"),
    ];

    return Column(
      children: features.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: _FeatureTile(icon: f.$1, label: f.$2, isMobile: isMobile),
        );
      }).toList(),
    );
  }

  // ─── Visual Section ─────────────────────────────────────────────────────────

  Widget _visualSection() {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final cardHeight = math.max(280.0, w * 0.82);

      return SizedBox(
        height: cardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Glass card background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.08),
                      AppColors.primaryColor.withOpacity(0.02),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.07),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
              ),
            ),

            // Grid pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: CustomPaint(
                    painter: _GridPainter(AppColors.primaryColor)),
              ),
            ),

            // Pulsing decorative ring
            Positioned(
              top: -18,
              right: -18,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Transform.scale(
                  scale: 1.0 + _pulseController.value * 0.08,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.13),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Center content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconBadge(),
                    const SizedBox(height: 22),
                    const Text(
                      "Trusted & Certified",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      "Smart automation systems with high\ndurability and modern engineering.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.baseGray,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 26),

                  ],
                ),
              ),
            ),

            // Bottom accent line
            Positioned(
              bottom: 0,
              left: 32,
              right: 32,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.primaryColor,
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _iconBadge() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 88 + _pulseController.value * 5,
              height: 88 + _pulseController.value * 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor
                    .withOpacity(0.05 + _pulseController.value * 0.03),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
            ),
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.32),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }


}

// ─── Hover-aware Feature Tile ─────────────────────────────────────────────────

class _FeatureTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isMobile;

  const _FeatureTile({
    required this.icon,
    required this.label,
    required this.isMobile,
  });

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primaryColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppColors.primaryColor.withOpacity(0.15)
                    : AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(widget.icon,
                  color: AppColors.primaryColor, size: 16),
            ),
            const SizedBox(width: 13),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.isMobile ? 13 : 14,
                fontWeight:
                _hovered ? FontWeight.w600 : FontWeight.w500,
                color: _hovered
                    ? AppColors.primaryColor
                    : const Color(0xFF3A3A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hover-aware Cert Badge ───────────────────────────────────────────────────

class _HoverBadge extends StatefulWidget {
  final IconData icon;
  final String label;

  const _HoverBadge({required this.icon, required this.label});

  @override
  State<_HoverBadge> createState() => _HoverBadgeState();
}

class _HoverBadgeState extends State<_HoverBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primaryColor.withOpacity(0.07)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.primaryColor.withOpacity(0.2)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(_hovered ? 0.04 : 0.06),
              blurRadius: _hovered ? 6 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(widget.icon,
                color: AppColors.primaryColor, size: 20),
            const SizedBox(height: 5),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A4A),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}