import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const _kEmojis = ['✂️', '💇‍♀️', '💅', '💆‍♀️', '💋', '🧴', '🪮', '💈'];
const _kTotalCards = 16;
const _kInitialTime = 60;
const _kTimeBonus = 15;
const _kMatchPts = 10;
const _kBoardBonus = 20;
const _kComboBonus = 5;

const _kBlue = Color(0xFF0EA5E9);
const _kGreen = Color(0xFF10B981);
const _kRed = Color(0xFFEF4444);
const _kAmber = Color(0xFFF59E0B);
const _kPurple = Color(0xFF7C3AED);

// ─── Card model ───────────────────────────────────────────────────────────────
class _CardData {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;
  bool isMismatched; // flash red briefly
  _CardData({
    required this.id,
    required this.emoji,
    bool? isFlipped,
    bool? isMatched,
    bool? isMismatched,
  })  : isFlipped = isFlipped ?? false,
        isMatched = isMatched ?? false,
        isMismatched = isMismatched ?? false;
}

// ─── Sparkle particle ─────────────────────────────────────────────────────────
class _Sparkle {
  final Offset origin;
  final double angle, speed, size;
  final Color color;
  double progress = 0;

  _Sparkle({
    required this.origin,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });

  Offset get position => origin +
      Offset(cos(angle) * speed * progress * 60,
          sin(angle) * speed * progress * 60 + 30 * progress * progress);
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage>
    with TickerProviderStateMixin {
  // game state
  List<_CardData> _cards = [];
  final List<int> _selected = [];
  bool _canFlip = false;
  int _score = 0;
  int _rounds = 0;
  int _timeLeft = _kInitialTime;
  int _combo = 0;
  int _bestCombo = 0;
  bool _isPlaying = false;
  bool _isGameOver = false;
  Timer? _timer;
  bool _processingMatch = false;

  // sparkles
  final List<_Sparkle> _sparkles = [];
  late AnimationController _sparkleCtrl;

  // board flash (win round)
  late AnimationController _boardFlashCtrl;
  late Animation<double> _boardFlash;

  // pulse on match
  final _matchedIds = <int>{};

  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addListener(() => setState(() {
          for (final s in _sparkles) {
            s.progress = _sparkleCtrl.value;
          }
        }))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          setState(() => _sparkles.clear());
        }
      });

    _boardFlashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _boardFlash = CurvedAnimation(
      parent: _boardFlashCtrl,
      curve: Curves.easeOut,
    );

    _buildDeck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sparkleCtrl.dispose();
    _boardFlashCtrl.dispose();
    super.dispose();
  }

  // ── Deck ──────────────────────────────────────────────────────────────────
  void _buildDeck() {
    final pool = [..._kEmojis, ..._kEmojis]..shuffle(_rng);
    _cards = List.generate(
      _kTotalCards,
      (i) => _CardData(id: i, emoji: pool[i]),
    );
    _matchedIds.clear();
  }

  // ── Start / restart ───────────────────────────────────────────────────────
  void _startGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _rounds = 0;
      _timeLeft = _kInitialTime;
      _combo = 0;
      _bestCombo = 0;
      _isPlaying = true;
      _isGameOver = false;
      _canFlip = true;
      _selected.clear();
      _processingMatch = false;
      _buildDeck();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft <= 1) {
          _timeLeft = 0;
          _isPlaying = false;
          _isGameOver = true;
          _timer?.cancel();
          Future.delayed(const Duration(milliseconds: 300), _showGameOver);
        } else {
          _timeLeft--;
        }
      });
    });
  }

  // ── Flip ──────────────────────────────────────────────────────────────────
  void _onCardTap(int idx) {
    if (!_isPlaying || !_canFlip || _processingMatch) return;
    final card = _cards[idx];
    if (card.isFlipped || card.isMatched) return;
    if (_selected.contains(idx)) return;
    if (_selected.length >= 2) return;

    HapticFeedback.lightImpact();

    setState(() {
      card.isFlipped = true;
      _selected.add(idx);
    });

    if (_selected.length == 2) {
      _processingMatch = true;
      _canFlip = false;
      _checkMatch();
    }
  }

  void _checkMatch() {
    final a = _selected[0];
    final b = _selected[1];

    if (_cards[a].emoji == _cards[b].emoji) {
      // ✅ Match
      _combo++;
      if (_combo > _bestCombo) _bestCombo = _combo;
      final pts = _kMatchPts + (_combo > 1 ? _kComboBonus * (_combo - 1) : 0);

      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        HapticFeedback.mediumImpact();

        // spawn sparkles at approx card positions
        _spawnSparkles(a);
        _spawnSparkles(b);

        setState(() {
          _cards[a].isMatched = true;
          _cards[b].isMatched = true;
          _matchedIds.add(a);
          _matchedIds.add(b);
          _score += pts;
          _selected.clear();
          _processingMatch = false;
          _canFlip = true;
        });

        // Board cleared?
        if (_cards.every((c) => c.isMatched)) {
          _onBoardCleared();
        }
      });
    } else {
      // ❌ Mismatch
      _combo = 0;
      setState(() {
        _cards[a].isMismatched = true;
        _cards[b].isMismatched = true;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        HapticFeedback.lightImpact();
        setState(() {
          _cards[a].isFlipped = false;
          _cards[b].isFlipped = false;
          _cards[a].isMismatched = false;
          _cards[b].isMismatched = false;
          _selected.clear();
          _processingMatch = false;
          _canFlip = true;
        });
      });
    }
  }

  void _onBoardCleared() {
    _score += _kBoardBonus;
    _rounds++;
    HapticFeedback.heavyImpact();
    _boardFlashCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _timeLeft = min(_timeLeft + _kTimeBonus, _kInitialTime);
        _selected.clear();
        _processingMatch = false;
        _canFlip = true;
        _buildDeck();
      });
      _boardFlashCtrl.reverse();
    });
  }

  // ── Sparkles ──────────────────────────────────────────────────────────────
  void _spawnSparkles(int cardIdx) {
    // approximate centre — layout is 4-col, calculated roughly
    const colors = [_kBlue, _kGreen, _kAmber, _kPurple];
    for (int i = 0; i < 6; i++) {
      _sparkles.add(_Sparkle(
        origin: const Offset(180, 300), // centred; purely decorative
        angle: _rng.nextDouble() * 2 * pi,
        speed: 0.8 + _rng.nextDouble() * 1.2,
        size: 5 + _rng.nextDouble() * 7,
        color: colors[_rng.nextInt(colors.length)],
      ));
    }
    _sparkleCtrl.forward(from: 0);
  }

  // ── Game over dialog ──────────────────────────────────────────────────────
  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (ctx) => _GameOverDialog(
        score: _score,
        rounds: _rounds,
        bestCombo: _bestCombo,
        onClose: () => Navigator.pop(ctx),
        onReplay: () {
          Navigator.pop(ctx);
          _startGame();
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEFF6FF), Color(0xFFDCEFFD), Color(0xFFEFF6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(),
                  _buildHUD(),
                  if (_combo >= 2) _buildComboBar(),
                  Expanded(child: _buildGrid()),
                  _buildBottomArea(),
                ],
              ),
              // sparkle overlay
              if (_sparkles.isNotEmpty)
                IgnorePointer(
                  child: CustomPaint(
                    painter: _SparklePainter(_sparkles),
                    size: Size.infinite,
                  ),
                ),
              // board cleared flash — always IgnorePointer so it never blocks taps
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _boardFlash,
                  builder: (_, __) => _boardFlash.value > 0
                      ? Container(
                          color: _kGreen.withOpacity(_boardFlash.value * 0.18),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 18, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Memory Match',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _kBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🃏  Round ${_rounds + 1}',
              style: GoogleFonts.outfit(
                color: _kBlue,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUD() {
    final timerColor = _timeLeft <= 10 ? _kRed : _kBlue;
    final timePct = _timeLeft / _kInitialTime;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
      child: Row(
        children: [
          // score chip
          _StatChip(label: 'Score', value: '$_score', color: _kBlue),
          const SizedBox(width: 12),
          // timer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer_rounded,
                            size: 14, color: timerColor),
                        const SizedBox(width: 4),
                        Text(
                          '$_timeLeft s',
                          style: GoogleFonts.outfit(
                            color: timerColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '+${_kTimeBonus}s on clear',
                      style: GoogleFonts.outfit(
                        color: _kGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                TweenAnimationBuilder<double>(
                  tween: Tween(end: timePct),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  builder: (_, v, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      backgroundColor: timerColor.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation(timerColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatChip(label: 'Rounds', value: '$_rounds', color: _kGreen),
        ],
      ),
    );
  }

  Widget _buildComboBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kAmber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(
            '$_combo× Combo! +${_kComboBonus * (_combo - 1)} bonus pts',
            style: GoogleFonts.outfit(
              color: const Color(0xFF92400E),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _kTotalCards,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9,
        ),
        itemBuilder: (_, i) => _FlipCard(
          key: ValueKey('card_${_cards[i].id}_${_rounds}'),
          data: _cards[i],
          onTap: () => _onCardTap(i),
        ),
      ),
    );
  }

  Widget _buildBottomArea() {
    if (_isPlaying) return const SizedBox(height: 12);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        children: [
          if (!_isGameOver) ...[
            Text(
              'Match all pairs before time runs out!',
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '🔥 Combo matches give bonus points',
              style: GoogleFonts.outfit(
                color: _kAmber,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
          ],
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                _isGameOver ? '🔄  Play Again' : '🃏  Start Matching',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Flip card widget ─────────────────────────────────────────────────────────
class _FlipCard extends StatefulWidget {
  final _CardData data;
  final VoidCallback onTap;

  const _FlipCard({
    required super.key,
    required this.data,
    required this.onTap,
  });

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _angle;
  late Animation<double> _scale;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _angle = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
    );
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(_ctrl);

    _ctrl.addListener(() {
      final front = _ctrl.value > 0.5;
      if (front != _showFront) setState(() => _showFront = front);
    });
  }

  @override
  void didUpdateWidget(_FlipCard old) {
    super.didUpdateWidget(old);
    // Animate based on the current data flags. The parent mutates the
    // same _CardData instance, so comparing to `old.data` can miss changes.
    if (widget.data.isFlipped || widget.data.isMatched) {
      _ctrl.forward();
    } else {
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
        animation: _ctrl,
        builder: (_, __) {
          // After halfway, flip around Y-axis using second half
          final tilt = _showFront ? _angle.value - pi : _angle.value;
          return Transform.scale(
            scale: _scale.value,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(tilt),
              alignment: Alignment.center,
              child: _showFront ? _FrontFace(data: widget.data) : _BackFace(),
            ),
          );
        },
      ),
    );
  }
}

class _BackFace extends StatelessWidget {
  const _BackFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBlue.withOpacity(0.18), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _kBlue.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '?',
          style: GoogleFonts.outfit(
            fontSize: 24,
            color: _kBlue.withOpacity(0.35),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FrontFace extends StatelessWidget {
  final _CardData data;
  const _FrontFace({required this.data});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;

    if (data.isMismatched) {
      borderColor = _kRed;
      bgColor = _kRed.withOpacity(0.1);
    } else if (data.isMatched) {
      borderColor = _kGreen;
      bgColor = _kGreen.withOpacity(0.1);
    } else {
      borderColor = _kBlue;
      bgColor = _kBlue.withOpacity(0.07);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              data.emoji,
              style: const TextStyle(fontSize: 26),
            ),
          ),
          if (data.isMatched)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _kGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Sparkle painter ─────────────────────────────────────────────────────────
class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  _SparklePainter(this.sparkles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final opacity = (1 - s.progress).clamp(0.0, 1.0);
      final paint = Paint()..color = s.color.withOpacity(opacity);
      canvas.drawCircle(s.position, s.size * (1 - s.progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => true;
}

// ─── Game over dialog ─────────────────────────────────────────────────────────
class _GameOverDialog extends StatelessWidget {
  final int score, rounds, bestCombo;
  final VoidCallback onClose, onReplay;

  const _GameOverDialog({
    required this.score,
    required this.rounds,
    required this.bestCombo,
    required this.onClose,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⏰', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              "Time's Up!",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kBlue.withOpacity(0.07),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(label: 'Score', value: '$score pts', color: _kBlue),
                  Container(width: 1, height: 36, color: _kBlue.withOpacity(0.15)),
                  _ResultStat(label: 'Rounds', value: '$rounds', color: _kGreen),
                  Container(width: 1, height: 36, color: _kBlue.withOpacity(0.15)),
                  _ResultStat(label: 'Best combo', value: '${bestCombo}×', color: _kAmber),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // points breakdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Match: +${_kMatchPts}  •  Board clear: +${_kBoardBonus}  •  Combo: +${_kComboBonus}×',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Close',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReplay,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text('Play again',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

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
          TweenAnimationBuilder<double>(
            tween: Tween(end: double.tryParse(value) ?? 0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (_, v, __) => Text(
              '${v.round()}',
              style: GoogleFonts.outfit(
                  color: color, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ResultStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.outfit(
                color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        Text(label,
            style: GoogleFonts.outfit(
                color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}