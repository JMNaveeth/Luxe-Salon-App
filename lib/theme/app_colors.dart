import 'package:flutter/material.dart';

/// ─── Luxe Salon — Unified Color Palette ────────────────────────────────────
/// Midnight Noir & Gold — Premium luxury salon theme.
/// Import this file in every page instead of defining colors locally.
class AppColors {
  AppColors._(); // prevent instantiation

  // ─── Backgrounds ────────────────────────────────────────────────────────────
  static const bg = Color(0xFFFFFFFF); // Basic white background
  static const surface = Color(0xFFF5F5F5); // Light gray surface
  static const card = Color(0xFFFFFFFF); // Card background (white)
  static const cardBorder = Color(0xFFDDDDDD); // Subtle border (light gray)

  // ─── Accent Colors ──────────────────────────────────────────────────────────
  static const gold = Color(0xFF2196F3); // Primary blue accent
  static const goldLight = Color(0xFF64B5F6); // Light blue
  static const goldDim = Color(0xFF1976D2); // Dark blue
  static const goldFaint = Color(0xFFBBDEFB); // Faint blue

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF212121); // Basic dark text
  static const textSecondary = Color(0xFF757575); // Secondary gray text
  static const textMuted = Color(0xFFBDBDBD); // Muted light gray text
  static const textLight = Color(0xFFFFFFFF); // Light text variant (white)

  // ─── Utility ───────────────────────────────────────────────────────────────
  static const divider = Color(0xFFEEEEEE); // Subtle separation (light gray)
  static const white = Color(0xFFFFFFFF); // Pure white
  static const error = Color(0xFFD32F2F); // Error / invalid (red)
  static const inactive = Color(0xFFBDBDBD); // Inactive elements (light gray)
  static const darkText = Color(
    0xFF212121,
  ); // Text on blue buttons (= dark text)

  // ─── Status Colors ─────────────────────────────────────────────────────────
  static const green = Color(0xFF388E3C); // Success / green
  static const greenFaint = Color(0xFFC8E6C9); // Green background wash
  static const red = Color(0xFFD32F2F); // Danger / red
  static const blue = Color(0xFF1976D2); // Info / blue
  static const blueFaint = Color(0xFFBBDEFB); // Blue background wash
  static const purple = Color(0xFF7B1FA2); // Highlight / purple
  static const purpleFaint = Color(0xFFE1BEE7); // Purple background wash
  static const orange = Color(0xFFFBC02D); // Warning / yellow
  static const orangeFaint = Color(0xFFFFF9C4); // Yellow background wash

  // ─── Component-Specific ────────────────────────────────────────────────────
  static const stepInactive = surface; // Inactive step indicator
  static const heartBg = Color(0x33FFFFFF); // Semi-transparent heart bg
  static const inputBg = surface; // Input field background
  static const inputBorder = cardBorder; // Input field border
  static const chipSelected = gold; // Selected chip (blue)
  static const chipUnselected = surface; // Unselected chip
  static const chartBar = goldDim; // Inactive chart bar (dark blue)
  static const chartBarActive = gold; // Active chart bar (blue)
  static const progressBg = cardBorder; // Progress track background
  static const toggleActive = gold; // Toggle on (blue)
  static const toggleInactive = cardBorder; // Toggle off
  static const darkGreen = green; // Dark accent area

  // ─── Aliases (backward compatibility) ──────────────────────────────────────
  static const background = bg; // Used in customer_home
  static const cardDark = card; // Used in customer_home
  static const tagBg = gold; // Tag background
  static const ratingBg = gold; // Rating badge background
  static const btnBg = gold; // Button background
}
