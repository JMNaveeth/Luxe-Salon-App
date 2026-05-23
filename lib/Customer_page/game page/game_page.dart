import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bottom_nav.dart';
import '../../theme/app_colors.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  late final List<int> _targetOrder;
  Timer? _timer;

  int _score = 0;
  int _timeLeft = 20;
  int _targetIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _targetOrder = List<int>.generate(9, (_) => _random.nextInt(9));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _timeLeft = 20;
      _targetIndex = _random.nextInt(9);
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        if (!mounted) return;
        setState(() {
          _timeLeft = 0;
          _isPlaying = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _timeLeft -= 1;
      });
    });
  }

  void _tapTile(int index) {
    if (!_isPlaying || _timeLeft == 0) return;

    if (index == _targetIndex) {
      setState(() {
        _score += 1;
        _targetIndex = _random.nextInt(9);
      });
    } else {
      setState(() {
        if (_score > 0) _score -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Center',
                          style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the golden target before time runs out',
                          style: GoogleFonts.outfit(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Score',
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$_score',
                            style: GoogleFonts.outfit(
                              color: AppColors.gold,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isPlaying ? '$_timeLeft s left' : 'Ready to play',
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _timeLeft / 20,
                        minHeight: 8,
                        backgroundColor: AppColors.gold.withOpacity(0.12),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ).copyWith(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _isPlaying ? 'Restart Game' : 'Start Game',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final isTarget = index == _targetIndex && _isPlaying;
                      return GestureDetector(
                        onTap: () => _tapTile(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            gradient:
                                isTarget ? AppColors.primaryGradient : null,
                            color: isTarget ? null : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color:
                                  isTarget
                                      ? Colors.transparent
                                      : AppColors.gold.withOpacity(0.08),
                            ),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Center(
                            child: Icon(
                              isTarget
                                  ? Icons.star_rounded
                                  : Icons.circle_outlined,
                              color:
                                  isTarget
                                      ? Colors.white
                                      : AppColors.textMuted.withOpacity(0.35),
                              size: isTarget ? 40 : 28,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LuxeBottomNav(currentIndex: 1),
    );
  }
}
