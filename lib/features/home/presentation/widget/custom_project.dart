import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/social_model.dart';

// ─── Helper: get accent color by platform name ────────────────────────────────
Color _accentForSocial(String title) {
  final t = title.toLowerCase();
  if (t.contains('whatsapp')) return const Color(0xFF25D366);
  if (t.contains('facebook')) return const Color(0xFF1877F2);
  if (t.contains('instagram')) return const Color(0xFFE1306C);
  if (t.contains('linkedin')) return const Color(0xFF0A66C2);
  if (t.contains('twitter') || t.contains('x')) return const Color(0xFF1DA1F2);
  if (t.contains('youtube')) return const Color(0xFFFF0000);
  if (t.contains('tiktok')) return const Color(0xFF010101);
  return const Color(0xFF2563EB); // default blue
}


// ─── Contact Section ──────────────────────────────────────────────────────────

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;
    final hPad = isMobile ? 20.0 : width < 1050 ? 40.0 : 80.0;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFAFAFC), Color(0xFFF0F4FF)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: isMobile ? 48 : 72,
            ),
            child: Column(
              children: [
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 40 : 56),
                _buildSocialGrid(isMobile),
                SizedBox(height: isMobile ? 48 : 64),
                _buildDivider(),
                SizedBox(height: isMobile ? 24 : 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        // Tag pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 3.5,
                backgroundColor: Color(0xFF2563EB),
              ),
              SizedBox(width: 8),
              Text(
                "GET IN TOUCH",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 16 : 20),

        Text(
          "Let's Work Together",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 26 : 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            height: 1.15,
            color: const Color(0xFF1A1A2E),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "Connect with us through any of the platforms below\nand let's build something great together.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 13 : 15,
            color: Colors.grey.shade500,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialGrid(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 12 : 20,
      runSpacing: isMobile ? 12 : 20,
      alignment: WrapAlignment.center,
      children: socialList
          .map((e) => SocialCard(social: e, isMobile: isMobile))
          .toList(),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.grey.shade300],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CircleAvatar(
            radius: 3,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade300, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

}

// ─── Social Card ──────────────────────────────────────────────────────────────

class SocialCard extends StatefulWidget {
  final SocialModel social;
  final bool isMobile;

  const SocialCard({
    super.key,
    required this.social,
    this.isMobile = false,
  });

  @override
  State<SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<SocialCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  // Resolved once so we don't call the helper on every build
  late final Color _accent;

  @override
  void initState() {
    super.initState();

    // ✅ Color resolved from title — no model change needed
    _accent = _accentForSocial(widget.social.title);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    final uri = Uri.parse(widget.social.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _scaleController.forward();
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final cardW = widget.isMobile ? 150.0 : 180.0;
    final cardH = widget.isMobile ? 110.0 : 130.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: _launch,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            width: cardW,
            height: cardH,
            decoration: BoxDecoration(
              color: _hovered ? _accent : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered ? _accent : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? _accent.withOpacity(0.28)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: _hovered ? 24 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon circle ──────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered
                        ? Colors.white.withOpacity(0.2)
                        : _accent.withOpacity(0.08),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.social.icon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Title ────────────────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                    _hovered ? Colors.white : const Color(0xFF1A1A2E),
                    letterSpacing: 0.2,
                  ),
                  child: Text(widget.social.title),
                ),

                const SizedBox(height: 4),

                // ── "Open ↗" hint ────────────────────────────────
                AnimatedOpacity(
                  opacity: _hovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Text(
                    "Open ↗",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}