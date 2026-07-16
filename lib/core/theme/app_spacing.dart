import 'package:flutter/material.dart';

/// Design system spacing scale.
/// Use these constants instead of raw numbers for consistency.
class AppSpacing {
  // ── Spacing Scale ──
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double section = 32.0;
  static const double page = 24.0;

  // ── Edge Insets ──
  static const EdgeInsets pagePadding = EdgeInsets.all(page);
  static const EdgeInsets pagePaddingH = EdgeInsets.symmetric(horizontal: page);
  static const EdgeInsets pagePaddingV = EdgeInsets.symmetric(vertical: page);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);

  // ── Border Radius ──
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;

  // ── Border Radius Objects ──
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // ── Heights ──
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double bottomNavHeight = 64.0;
  static const double appBarHeight = 56.0;

  // ── Icon Sizes ──
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ── Avatar Sizes ──
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 80.0;

  // ── Dividers ──
  static const double dividerThin = 1.0;
}
