import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import 'custom_contact.dart';

class HomeHeaderScreen extends StatefulWidget {
  final VoidCallback onAboutTap;
  final VoidCallback onProjectTap;
  final VoidCallback onLocationTap;

  const HomeHeaderScreen({
    super.key,
    required this.onAboutTap,
    required this.onProjectTap,
    required this.onLocationTap,
  });

  @override
  State<HomeHeaderScreen> createState() => _HomeHeaderScreenState();
}

class _HomeHeaderScreenState extends State<HomeHeaderScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool showContactMenu = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> items = [
    AppStrings.home,
    AppStrings.about,
    AppStrings.project,
    AppStrings.location, // ✅ NEW
    AppStrings.contact,
  ];

  final List<IconData> itemIcons = [
    Icons.home_rounded,
    Icons.person_rounded,
    Icons.work_rounded,
    Icons.location_on_rounded, // ✅ NEW
    Icons.mail_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;

      switch (index) {
        case 1:
          widget.onAboutTap();
          break;
        case 2:
          widget.onProjectTap();
          break;
        case 3:
          widget.onLocationTap(); // ✅ هنا الصح
          break;
      }

      showContactMenu =
      index == 4 ? !showContactMenu : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;
    final isTablet = width >= 650 && width < 1000;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(isMobile, isTablet),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: child,
            ),
          ),
          child: showContactMenu
              ? const Padding(
            key: ValueKey('contact'),
            padding: EdgeInsets.only(top: 4),
            child: CustomContact(),
          )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    final hPad = isMobile ? 16.0 : isTablet ? 28.0 : 48.0;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor.withOpacity(0.06),
                Colors.white.withOpacity(0.92),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: hPad,
            vertical: isMobile ? 12 : 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBrand(isMobile),
              ),
              const Spacer(),
              if (isMobile)
                _buildMobileMenuButton(context)
              else
                _buildDesktopNav(isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.7),
            ],
          ).createShader(bounds),
          child: Text(
            AppStrings.naialShutter,
            style: TextStyle(
              fontSize: isMobile ? 17 : 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          AppStrings.spacesLikeHome,
          style: TextStyle(
            fontSize: isMobile ? 10 : 11,
            color: AppColors.baseGray.withOpacity(0.7),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopNav(bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 2 : 4),
          child: _WebNavItem(
            text: items[index],
            icon: itemIcons[index],
            isSelected: selectedIndex == index,
            isTablet: isTablet,
            onTap: () => _onItemTap(index),
          ),
        );
      }),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMobileDrawer(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.menu_rounded,
          color: AppColors.primaryColor,
          size: 20,
        ),
      ),
    );
  }

  void _showMobileDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MobileNavDrawer(
        items: items,
        icons: itemIcons,
        selectedIndex: selectedIndex,
        onItemTap: (index) {
          Navigator.pop(context);
          _onItemTap(index);
        },
      ),
    );
  }
}

// ─── Web Nav Item with Hover ──────────────────────────────────────────────────

class _WebNavItem extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final bool isTablet;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.isTablet,
    required this.onTap,
  });

  @override
  State<_WebNavItem> createState() => _WebNavItemState();
}

class _WebNavItemState extends State<_WebNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isTablet ? 12 : 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primaryColor.withOpacity(0.1)
                : _hovered
                ? AppColors.primaryColor.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primaryColor.withOpacity(0.22)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: widget.isSelected
                    ? Padding(
                  key: ValueKey('on_${widget.text}'),
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    widget.icon,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                )
                    : const SizedBox.shrink(key: ValueKey('off')),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: widget.isTablet ? 13 : 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: active
                      ? AppColors.primaryColor
                      : AppColors.baseGray,
                  letterSpacing: 0.2,
                ),
                child: Text(widget.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Drawer ────────────────────────────────────────────────────────────

class _MobileNavDrawer extends StatelessWidget {
  final List<String> items;
  final List<IconData> icons;
  final int selectedIndex;
  final void Function(int) onItemTap;

  const _MobileNavDrawer({
    required this.items,
    required this.icons,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.1)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ...List.generate(items.length, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withOpacity(0.09)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.18)
                              : Colors.transparent,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => onItemTap(index),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.14)
                                : AppColors.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            icons[index],
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.baseGray,
                            size: 17,
                          ),
                        ),
                        title: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.baseGray,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.chevron_right_rounded,
                            color: AppColors.primaryColor, size: 20)
                            : null,
                        dense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}