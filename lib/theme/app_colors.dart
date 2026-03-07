import 'package:flutter/material.dart';

/// ─── Luxe Salon — Unified Color Palette ────────────────────────────────────
/// Midnight Noir & Gold — Premium luxury salon theme.
/// Import this file in every page instead of defining colors locally.
class AppColors {
  AppColors._(); // prevent instantiation

  // ─── Backgrounds ────────────────────────────────────────────────────────────
  static const bg = Color(0xFF060610); // Deep midnight base
  static const surface = Color(0xFF0D0D1A); // Elevated surface
  static const card = Color(0xFF131322); // Card background
  static const cardBorder = Color(0xFF20203A); // Subtle borders

  // ─── Gold Accents ──────────────────────────────────────────────────────────
  static const gold = Color(0xFFC8A24E); // Rich classic gold
  static const goldLight = Color(0xFFDFC06E); // Light gold highlight
  static const goldDim = Color(0xFF483A12); // Dim gold accent
  static const goldFaint = Color(0xFF141008); // Very faint gold wash

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFFEBE8E0); // Warm platinum white
  static const textSecondary = Color(0xFF747490); // Cool neutral gray
  static const textMuted = Color(0xFF3C3C55); // Muted dark text
  static const textLight = Color(0xFFC8C8DD); // Light text variant

  // ─── Utility ───────────────────────────────────────────────────────────────
  static const divider = Color(0xFF181828); // Subtle separation
  static const white = Color(0xFFFFFFFF); // Pure white
  static const error = Color(0xFFCF6679); // Error / invalid
  static const inactive = Color(0xFF35355A); // Inactive elements
  static const darkText = Color(0xFF060610); // Text on gold buttons (= bg)

  // ─── Status Colors ─────────────────────────────────────────────────────────
  static const green = Color(0xFF42D4A0); // Success / mint green
  static const greenFaint = Color(0xFF081815); // Green background wash
  static const red = Color(0xFFE85B68); // Danger / coral red
  static const blue = Color(0xFF5B9CD4); // Info / clear blue
  static const blueFaint = Color(0xFF0A1520); // Blue background wash
  static const purple = Color(0xFF9B7FD4); // Highlight / lavender
  static const purpleFaint = Color(0xFF110E20); // Purple background wash
  static const orange = Color(0xFFD49060); // Warning / amber
  static const orangeFaint = Color(0xFF18100A); // Orange background wash

  // ─── Component-Specific ────────────────────────────────────────────────────
  static const stepInactive = card; // Inactive step indicator
  static const heartBg = Color(0x33FFFFFF); // Semi-transparent heart bg
  static const inputBg = surface; // Input field background
  static const inputBorder = cardBorder; // Input field border
  static const chipSelected = cardBorder; // Selected chip
  static const chipUnselected = surface; // Unselected chip
  static const chartBar = cardBorder; // Inactive chart bar
  static const chartBarActive = gold; // Active chart bar
  static const progressBg = cardBorder; // Progress track background
  static const toggleActive = gold; // Toggle on
  static const toggleInactive = cardBorder; // Toggle off
  static const darkGreen = Color(0xFF0A1520); // Dark accent area

  // ─── Aliases (backward compatibility) ──────────────────────────────────────
  static const background = bg; // Used in customer_home
  static const cardDark = card; // Used in customer_home
  static const tagBg = gold; // Tag background
  static const ratingBg = gold; // Rating badge background
  static const btnBg = gold; // Button background
}
