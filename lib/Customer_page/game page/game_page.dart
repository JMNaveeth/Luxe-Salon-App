import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bottom_nav.dart';
import '../../theme/app_colors.dart';
import 'Memory_match_page.dart';
import 'Spin_wheel_page.dart';
// import 'games/catch_tool_page.dart';
// import 'games/emoji_algebra_page.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      _GameInfo(
        title: 'Spin the Wheel',
        subtitle: 'Once daily • Up to 100 pts',
        description: 'Spin for reward points, coupons & free trials. New spin every 24 hours!',
        emoji: '🎡',
        accentColor: const Color(0xFF7C3AED),
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFA855F7)]),
        badge: 'Daily',
        page: const SpinWheelPage(),
      ),
      _GameInfo(
        title: 'Memory Match',
        subtitle: 'Flip cards • +15 pts / round',
        description: 'Match pairs of salon tools before the timer runs out!',
        emoji: '🃏',
        accentColor: const Color(0xFF0EA5E9),
        gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)]),
        badge: 'Brain',
        page: const MemoryMatchPage(),
      ),
      // _GameInfo(
      //   title: 'Catch the Tool',
      //   subtitle: 'Tap & catch • +20 pts / level',
      //   description: 'Slide the tray to catch the right falling salon tools!',
      //   emoji: '✂️',
      //   accentColor: const Color(0xFF10B981),
      //   gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
      //   badge: 'Reflex',
      //   page: const CatchToolPage(),
      // ),
      // _GameInfo(
      //   title: 'Emoji Algebra',
      //   subtitle: 'Solve puzzles • +15 pts each',
      //   description: 'Crack the salon emoji equations to find the missing value!',
      //   emoji: '🧮',
      //   accentColor: const Color(0xFFF59E0B),
      //   gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
      //   badge: 'Puzzle',
      //   page: const EmojiAlgebraPage(),
      // ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F9FF), Color(0xFFE9F1FF), Color(0xFFF7FBFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Center',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Play games, earn reward points',
                      style: GoogleFonts.outfit(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  itemCount: games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, i) => _GameCard(info: games[i]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LuxeBottomNav(currentIndex: 1),
    );
  }
}

class _GameInfo {
  final String title, subtitle, description, emoji, badge;
  final Color accentColor;
  final LinearGradient gradient;
  final Widget page;
  const _GameInfo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.emoji,
    required this.badge,
    required this.accentColor,
    required this.gradient,
    required this.page,
  });
}

class _GameCard extends StatelessWidget {
  final _GameInfo info;
  const _GameCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => info.page),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: info.gradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(info.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    info.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: info.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    info.badge,
                    style: GoogleFonts.outfit(
                      color: info.accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              info.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: info.accentColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              info.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 11,
                height: 1.3,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}