import 'package:flutter/material.dart';

/// ─── Luxe Salon — Unified Color Palette ────────────────────────────────────
/// Soft glassmorphism with blue-violet linear gradients.
/// Import this file in every page instead of defining colors locally.
class AppColors {
  AppColors._(); // prevent instantiation

  // ─── Gradients ─────────────────────────────────────────────────────────────
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8FBFF), Color(0xFFE9F1FF), Color(0xFFDCE8FF)],
  );
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B8CFF), Color(0xFF6A5CFF), Color(0xFF3FD1C1)],
  );
  static const secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF3F7FF), Color(0xFFE8EEFF)],
  );
  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7DB2FF), Color(0xFF4F8CFF)],
  );
  static const shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFFE8EEFF),
      Color(0xFFF8FBFF),
      Color(0xFFE8EEFF),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  static const heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF3A5FE5),
      Color(0xFF5B8CFF),
      Color(0xFF7DB2FF),
    ],
  );
  static const cardGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x0A4F8CFF), Color(0x054F8CFF)],
  );

  // ─── Backgrounds ────────────────────────────────────────────────────────────
  static const bg = Color(0xFFF5F8FF); // Soft app background
  static const surface = Color(0xFFFFFFFF); // Elevated surface
  static const card = Color(0xFFF9FBFF); // Card background
  static const cardBorder = Color(0xFFD7E2F6); // Soft border
  static const surfaceElevated = Color(0xFFFBFCFF); // Slightly elevated

  // ─── Accent Colors ──────────────────────────────────────────────────────────
  static const gold = Color(0xFF4F8CFF); // Primary accent blue
  static const goldLight = Color(0xFF9EC0FF); // Light sky blue
  static const goldDim = Color(0xFF2F63D6); // Dim blue
  static const goldFaint = Color(0xFFEAF1FF); // Faint blue wash

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF0E1B33); // Main text
  static const textSecondary = Color(0xFF51627E); // Secondary text
  static const textMuted = Color(0xFF7E8CA5); // Muted text
  static const textLight = Color(0xFF95A3BA); // Light text variant

  // ─── Utility ───────────────────────────────────────────────────────────────
  static const divider = Color(0xFFE3EAF8); // Subtle separation
  static const white = Color(0xFFFFFFFF); // Pure white
  static const error = Color(0xFFFF6B7A); // Error / invalid
  static const inactive = Color(0xFFCFD9EA); // Inactive elements
  static const darkText = Color(0xFF0B1630); // Text on blue buttons

  // ─── Status Colors ─────────────────────────────────────────────────────────
  static const green = Color(0xFF2BB673); // Success / mint green
  static const greenFaint = Color(0xFFE7FBF1); // Green background wash
  static const red = Color(0xFFFF5C6F); // Danger / coral red
  static const pink = Color(0xFFFF4FA3); // Favorite / rose pink
  static const pinkFaint = Color(0xFFFFE3F1); // Favorite background wash
  static const blue = Color(0xFF4F8CFF); // Info / electric blue
  static const blueFaint = Color(0xFFEAF1FF); // Blue background wash
  static const purple = Color(0xFF7C6CFF); // Highlight / periwinkle
  static const purpleFaint = Color(0xFFF0ECFF); // Purple-blue background wash
  static const orange = Color(0xFFFFA44D); // Warning / amber
  static const orangeFaint = Color(0xFFFFF0E2); // Orange background wash

  // ─── Component-Specific ────────────────────────────────────────────────────
  static const stepInactive = cardBorder; // Inactive step indicator
  static const heartBg = Color(0x26FFFFFF); // Semi-transparent heart bg
  static const inputBg = Color(0xFFF3F7FF); // Input field background
  static const inputBorder = cardBorder; // Input field border
  static const chipSelected = gold; // Selected chip (electric blue)
  static const chipUnselected = Color(0xFFE9EEF8); // Unselected chip
  static const chartBar = goldDim; // Inactive chart bar (dim blue)
  static const chartBarActive = gold; // Active chart bar (electric blue)
  static const progressBg = cardBorder; // Progress track background
  static const toggleActive = gold; // Toggle on (electric blue)
  static const toggleInactive = cardBorder; // Toggle off
  static const darkGreen = green; // Dark accent area

  // ─── Aliases (backward compatibility) ──────────────────────────────────────
  static const background = bg; // Used in customer_home
  static const cardDark = card; // Used in customer_home
  static const tagBg = gold; // Tag background (electric blue)
  static const ratingBg = gold; // Rating badge background (electric blue)
  static const btnBg = gold; // Button background (electric blue)

  // ─── Premium Shadows ───────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: gold.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: textPrimary.withOpacity(0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: gold.withOpacity(0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: gold.withOpacity(0.2),
      blurRadius: 30,
      spreadRadius: 2,
    ),
  ];
}
