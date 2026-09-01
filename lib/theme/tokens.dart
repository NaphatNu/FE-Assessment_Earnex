import 'package:flutter/material.dart';

/// Design tokens mirrored from the Figma "Design Foundation" variable
/// collections (Primitive / Semantic / Spacing / Typography).
///
/// Every value here has a one-to-one counterpart in Figma; nothing is
/// invented. Widgets read from this file instead of repeating raw hex.
class AppColors {
  const AppColors._();

  // Primitive — brand
  static const brandYellow500 = Color(0xFFF0B90B);
  static const brandYellow400 = Color(0xFFF8D12F);
  static const brandYellow100 = Color(0xFFFEF6D8);

  // Primitive — neutral
  static const black = Color(0xFF1E2329);
  static const gray900 = Color(0xFF474D57);
  static const gray700 = Color(0xFF707A8A);
  static const gray500 = Color(0xFF848E9C);
  static const gray400 = Color(0xFFA1A7B3);
  static const gray300 = Color(0xFFB7BDC6);
  static const gray200 = Color(0xFFEAECEF);
  static const gray150 = Color(0xFFF0F0F0);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray50 = Color(0xFFFAFAFA);
  static const white = Color(0xFFFFFFFF);

  // Primitive — status
  static const green500 = Color(0xFF0ECB81);
  static const green100 = Color(0xFFE6FAF0);
  static const red500 = Color(0xFFF6465D);
  static const red100 = Color(0xFFFDE8EB);

  // Semantic — background
  static const bgPrimary = white;
  static const bgSecondary = gray100;
  static const bgTertiary = gray50;
  static const bgBrand = brandYellow500;
  static const bgBrandLight = brandYellow100;
  static const bgDisabled = gray150;

  // Semantic — text
  static const textPrimary = black;
  static const textSecondary = gray700;
  static const textTertiary = gray300;
  static const textDisabled = gray400;
  static const textSuccess = green500;
  static const textError = red500;

  // Semantic — border
  static const borderDefault = gray200;
  static const borderStrong = black;
  static const borderBrand = brandYellow500;

  // Semantic — icon
  static const iconPrimary = black;
  static const iconSecondary = gray700;

  /// Card background wash — Figma "BG / Property 1=spot".
  static const cardWashStart = Color(0xFFFFF7E0);
  static const cardWashEnd = white;

  /// The blurred gold ellipse layered over the card wash.
  static const cardGlow = Color(0xFFD89F00);
}

/// Spacing scale — Figma `spacing/*`.
class AppSpacing {
  const AppSpacing._();

  static const double x2 = 2;
  static const double x4 = 4;
  static const double x8 = 8;
  static const double x12 = 12;
  static const double x16 = 16;
  static const double x20 = 20;
  static const double x24 = 24;
  static const double x32 = 32;
}

/// Corner radii — Figma `radius/*`.
class AppRadius {
  const AppRadius._();

  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 999;
}

/// Text styles — Figma text styles, each `fontSize/lineHeight` pair taken
/// from the Typography collection.
class AppText {
  const AppText._();

  static const String _family = 'Inter';

  static const TextStyle regular12 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle medium12 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle semiBold12 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle medium14 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle semiBold14 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle semiBold16 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 22 / 16,
  );

  static const TextStyle bold20 = TextStyle(
    fontFamily: _family,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 28 / 20,
  );
}

/// Paths to the icon bitmaps exported straight out of the Figma file.
class AppIcons {
  const AppIcons._();

  static const String chevronDown20 = 'assets/icons/chevron_down_20.png';
  static const String chevronDown16 = 'assets/icons/chevron_down_16.png';
  static const String chevronRight16 = 'assets/icons/chevron_right_16.png';
  static const String playCircle = 'assets/icons/play_circle.png';
  static const String leadTrader = 'assets/icons/lead_trader.png';
  static const String filterList = 'assets/icons/filter_list.png';
  static const String users12 = 'assets/icons/users_12.png';
  static const String avatarRing = 'assets/icons/avatar_ring.png';
}
