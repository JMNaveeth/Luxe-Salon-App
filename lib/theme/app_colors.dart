import 'package:flutter/material.dart';

/// ─── Luxe Salon — Unified Color Palette ────────────────────────────────────
/// Midnight Navy & Sapphire — Premium luxury salon theme.
/// Import this file in every page instead of defining colors locally.
class AppColors {
  AppColors._(); // prevent instantiation

  // ─── Backgrounds ────────────────────────────────────────────────────────────
  static const bg = Colors.white; // Deep midnight navy background
  static const surface = Color(0xFF151728); // Elevated surface (dark navy)
  static const card = Colors.grey; // Card background (dark navy)
  static const cardBorder = Colors.blueGrey; // Subtle border (deep indigo)

  // ─── Accent Colors ──────────────────────────────────────────────────────────
  static const gold = Color(0xFF4A9EFF); // Electric sapphire blue (primary accent)
  static const goldLight = Color(0xFF80BFFF); // Light sky blue
  static const goldDim = Color(0xFF0A1F3D); // Dim blue (dark wash)
  static const goldFaint = Color(0xFF1E2140); // Faint blue (matches border)

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Colors.black; // Soft cool white text
  static const textSecondary = Colors.black87; // Muted steel-blue text
  static const textMuted = Colors.black45; // Muted dark text
  static const textLight = Colors.black54; // Light text variant (white)

  // ─── Utility ───────────────────────────────────────────────────────────────
  static const divider = Color(
    0xFF151728,
  ); // Subtle separation (matches surface)
  static const white = Color(0xFFFFFFFF); // Pure white
  static const error = Color(0xFFE85B68); // Error / invalid (coral red)
  static const inactive = Color(0xFF1E2A4A); // Inactive elements (deep navy slate)
  static const darkText = Color(0xFF0D0F1A); // Text on blue buttons (= bg)

  // ─── Status Colors ─────────────────────────────────────────────────────────
  static const green = Colors.green; // Success / mint green
  static const greenFaint = Color(0xFF081815); // Green background wash
  static const red = Colors.red; // Danger / coral red
  static const blue = Color(0xFF4A9EFF); // Info / electric blue (matches accent)
  static const blueFaint = Color(0xFF060E1F); // Blue background wash
  static const purple = Color(0xFF7C9FE8); // Highlight / periwinkle blue
  static const purpleFaint = Color(0xFF0A0E20); // Purple-blue background wash
  static const orange = Color(0xFFD49060); // Warning / amber
  static const orangeFaint = Color(0xFF18100A); // Orange background wash

  // ─── Component-Specific ────────────────────────────────────────────────────
  static const stepInactive = cardBorder; // Inactive step indicator
  static const heartBg = Color(0x33FFFFFF); // Semi-transparent heart bg
  static const inputBg = surface; // Input field background
  static const inputBorder = cardBorder; // Input field border
  static const chipSelected = gold; // Selected chip (electric blue)
  static const chipUnselected = surface; // Unselected chip
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
}