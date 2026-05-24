import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

const _kEmojis = ['✂️', '💇‍♀️', '💅', '💆‍♀️', '💋', '🧴', '🪮', '💈'];
const _kTotalCards = 16; // 4×4 grid, 8 pairs

// ─── Card model ──────────────────────────────────────────────────────────────
class _Card {
  final int id;
  final String emoji;
  bool isFlipped = false;
  bool isMatched = false;
  _Card({required this.id, required this.emoji});
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  List<_Card> _cards = [];
  List<int> _selected = [];
  bool _canFlip = true;
  int _score = 0;
  int _rounds = 0;
  int _timeLeft = 60;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _buildDeck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Deck ──────────────────────────────────────────────────────────────────
  void _buildDeck() {
    final pool = [..._kEmojis, ..._kEmojis]..shuffle();
    _cards = List.generate(_kTotalCards, (i) => _Card(id: i, emoji: pool[i]));
  }

  // ── Game start / restart ──────────────────────────────────────────────────
  void _startGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _rounds = 0;
      _timeLeft = 60;
      _isPlaying = true;
      _selected.clear();
      _canFlip = true;
      _buildDeck();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_timeLeft <= 1) {
        _timer?.cancel();
        setState(() {
          _timeLeft = 0;
          _isPlaying = false;
        });
        _showGameOver();
        return;
      }
      setState(() => _timeLeft--);
    });
  }

  // ── Flip logic ────────────────────────────────────────────────────────────
  void _flip(int idx) {
    if (!_isPlaying || !_canFlip) return;
    if (_cards[idx].isFlipped || _cards[idx].isMatched) return;
    if (_selected.length >= 2) return;

    setState(() {
      _cards[idx].isFlipped = true;
      _selected.add(idx);
    });

    if (_selected.length == 2) {
      _canFlip = false;
      final a = _selected[0];
      final b = _selected[1];

      if (_cards[a].emoji == _cards[b].emoji) {
        // ✅ Match
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          setState(() {
            _cards[a].isMatched = true;
            _cards[b].isMatched = true;
            _selected.clear();
            _score += 5;
            _canFlip = true;
          });

          // Win check
          if (_cards.every((c) => c.isMatched)) {
            _score += 10; // bonus
            _rounds++;
            Future.delayed(const Duration(milliseconds: 350), () {
              if (!mounted) return;
              setState(() {
                _timeLeft = min(_timeLeft + 15, 60);
                _buildDeck();
                _selected.clear();
              });
            });
          }
        });
      } else {
        // ❌ No match
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() {
            _cards[a].isFlipped = false;
            _cards[b].isFlipped = false;
            _selected.clear();
            _canFlip = true;
          });
        });
      }
    }
  }

  // ── Game over ─────────────────────────────────────────────────────────────
  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏰', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 12),
              Text('Time\'s Up!',
                  style: GoogleFonts.outfit(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Score: $_score pts   •   Rounds: $_rounds',
                  style: GoogleFonts.outfit(
                      fontSize: 14, color: const Color(0xFF0EA5E9))),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Close',
                          style: GoogleFonts.outfit(
                              color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _startGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Again!',
                          style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final timerColor =
        _timeLeft <= 10 ? const Color(0xFFEF4444) : const Color(0xFF0EA5E9);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── App bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      color: AppColors.textPrimary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Memory Match',
                        style: GoogleFonts.outfit(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ),

              // ── Stats
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    _Chip(
                      label: 'Score',
                      value: '$_score',
                      color: const Color(0xFF0EA5E9),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('⏱',
                                  style: const TextStyle(fontSize: 13)),
                              Text(
                                '$_timeLeft s',
                                style: GoogleFonts.outfit(
                                    color: timerColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _timeLeft / 60,
                              minHeight: 7,
                              backgroundColor: timerColor.withOpacity(0.15),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(timerColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _Chip(
                      label: 'Rounds',
                      value: '$_rounds',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),

              // ── Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kTotalCards,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                    ),
                    itemBuilder: (_, i) => _FlipTile(
                      card: _cards[i],
                      onTap: () => _flip(i),
                    ),
                  ),
                ),
              ),

              // ── Start button
              if (!_isPlaying)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(
                        '🃏  Start Matching',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Flip tile ─────────────────────────────────────────────────────────────────
class _FlipTile extends StatefulWidget {
  final _Card card;
  final VoidCallback onTap;
  const _FlipTile({required this.card, required this.onTap});

  @override
  State<_FlipTile> createState() => _FlipTileState();
}

class _FlipTileState extends State<_FlipTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _flip;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _flip = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_FlipTile old) {
    super.didUpdateWidget(old);
    if (widget.card.isFlipped && !old.card.isFlipped) {
      _ctrl.forward();
    } else if (!widget.card.isFlipped && old.card.isFlipped) {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flip,
        builder: (_, __) {
          final v = _flip.value;
          final isFront = v > 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi * v),
            alignment: Alignment.center,
            child: isFront
                ? _buildFront()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF0EA5E9).withOpacity(0.15), width: 1.5),
        boxShadow: AppColors.cardShadow,
      ),
      child: Center(
        child: Text('?',
            style: GoogleFonts.outfit(
                fontSize: 22,
                color: const Color(0xFF0EA5E9).withOpacity(0.4),
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFront() {
    final isMatched = widget.card.isMatched;
    return Container(
      decoration: BoxDecoration(
        color: isMatched
            ? const Color(0xFF10B981).withOpacity(0.12)
            : const Color(0xFF0EA5E9).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMatched
              ? const Color(0xFF10B981)
              : const Color(0xFF0EA5E9),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(widget.card.emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }
}

// ─── Stat chip ────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Chip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}