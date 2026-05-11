import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/role_selection_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const LuxeApp());
}

class LuxeApp extends StatelessWidget {
  const LuxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxe Salon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          primary: AppColors.gold,
          surface: AppColors.bg,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const RoleSelectionPage(),
    );
  }
}
