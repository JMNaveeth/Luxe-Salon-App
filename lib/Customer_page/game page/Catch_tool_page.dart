import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class CatchToolPage extends StatefulWidget {
  const CatchToolPage({super.key});

  @override
  State<CatchToolPage> createState() => _CatchToolPageState();
}

class _CatchToolPageState extends State<CatchToolPage>
    with TickerProviderStateMixin {
  // ── layout constants ──────────────────────────────────────────────────
  static const double _canvasW = double.infinity;
  static const double _canvasH = 440.0;
  static const double _basketW = 72.0;
  static const double _basketH = 36.0;
  static const double _itemSize = 36.0;
  static const double _floorY = _canvasH - _basketH - 8;

  // ── game state ────────────────────────────────────────────────────────
  bool _running = false;
  bool _gameOver = false;
  int _score = 0;
  int _level = 1;
  int _lives = 3;
  int _totalPts = 0;

  double _basketX = 160.0; // centre-x of basket
  double _actualWidth = 360.0; // set from LayoutBuilder

  final List<_FallingItem> _items = [];
  Timer? _gameTimer;
  Timer? _spawnTimer;
  int _tickCount = 0;

  // ── tools pool ────────────────────────────────────────────────────────
  static const _tools = ['✂️', '💅', '🪮', '💇', '💈', '🧴', '🪞'];
  // bad items to avoid
  static const _bads = ['🚫', '💣'];
  final _rng = Random();

  // ── animation ─────────────────────────────────────────────────────────
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── game loop (60 fps via periodic timer) ─────────────────────────────
  void _startGame() {
    setState(() {
      _running = true;
      _gameOver = false;
      _score = 0;
      _level = 1;
      _lives = 3;
      _totalPts = 0;
      _items.clear();
      _tickCount = 0;
      _basketX = _actualWidth / 2;
    });

    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_running) return;
      _tick();
    });

    _scheduleSpawn();
  }

  double get _dropSpeed => 1.6 + (_level - 1) * 0.5;
  int get _spawnMs => max(500, 1400 - (_level - 1) * 120);

  void _scheduleSpawn() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer(Duration(milliseconds: _spawnMs), () {
      if (!_running) return;
      _spawnItem();
      _scheduleSpawn();
    });
  }

  void _spawnItem() {
    final isBad = _level >= 3 && _rng.nextDouble() < 0.2;
    final emoji = isBad
        ? _bads[_rng.nextInt(_bads.length)]
        : _tools[_rng.nextInt(_tools.length)];
    setState(() {
      _items.add(_FallingItem(
        x: _itemSize / 2 + _rng.nextDouble() * (_actualWidth - _itemSize),
        y: -_itemSize,
        emoji: emoji,
        speed: _dropSpeed + _rng.nextDouble() * 0.6,
        isBad: isBad,
      ));
    });
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      _tickCount++;
      final toRemove = <_FallingItem>[];

      for (final item in _items) {
        item.y += item.speed;

        // reached floor area — check catch
        if (item.y >= _floorY) {
          final hit = (item.x - _basketX).abs() < (_basketW / 2 + _itemSize / 3);
          if (hit) {
            if (item.isBad) {
              _lives--;
              _shakeCtrl.forward(from: 0);
            } else {
              _score++;
              // level up every 6 catches
              if (_score % 6 == 0) {
                _level++;
                _totalPts += 20;
                _scheduleSpawn(); // refresh spawn rate
              }
            }
          } else if (!item.isBad) {
            // missed good item
            _lives--;
            _shakeCtrl.forward(from: 0);
          }
          toRemove.add(item);
        }
      }
      _items.removeWhere((i) => toRemove.contains(i));

      if (_lives <= 0) _endGame();
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    setState(() {
      _running = false;
      _gameOver = true;
      _items.clear();
    });
  }

  void _moveBasket(Offset localPos) {
    if (!_running) return;
    setState(() {
      _basketX = localPos.dx.clamp(_basketW / 2, _actualWidth - _basketW / 2);
    });
  }

  // ── UI ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10B981)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Catch the Tool',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$_totalPts pts',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHUD(),
          Expanded(child: _buildCanvas()),
          if (!_running) _buildActionArea(),
        ],
      ),
    );
  }

  Widget _buildHUD() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _hudChip(Icons.catching_pokemon_rounded, 'Score', '$_score',
              const Color(0xFF10B981)),
          _hudChip(Icons.speed_rounded, 'Level', '$_level',
              const Color(0xFF0EA5E9)),
          _hudChip(Icons.favorite_rounded, 'Lives',
              List.generate(3, (i) => i < _lives ? '❤️' : '🖤').join(),
              const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _hudChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value,
              style: GoogleFonts.outfit(
                  color: color, fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return LayoutBuilder(builder: (context, constraints) {
      _actualWidth = constraints.maxWidth;
      return GestureDetector(
        onPanUpdate: (d) => _moveBasket(d.localPosition),
        onTapDown: (d) => _moveBasket(d.localPosition),
        child: AnimatedBuilder(
          animation: _shakeAnim,
          builder: (context, child) {
            final shake =
                _shakeCtrl.isAnimating ? sin(_shakeAnim.value) * 4 : 0.0;
            return Transform.translate(
              offset: Offset(shake, 0),
              child: child,
            );
          },
          child: Container(
            width: double.infinity,
            height: _canvasH,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFF0FDF4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                // falling items
                ..._items.map((item) => Positioned(
                      left: item.x - _itemSize / 2,
                      top: item.y,
                      child: Text(item.emoji,
                          style: const TextStyle(fontSize: _itemSize - 4)),
                    )),

                // basket
                if (_running || _gameOver)
                  Positioned(
                    left: _basketX - _basketW / 2,
                    top: _floorY,
                    child: _buildBasket(),
                  ),

                // overlay states
                if (!_running && !_gameOver) _buildStartOverlay(),
                if (_gameOver) _buildGameOverOverlay(),

                // level-up flash
                if (_running && _score > 0 && _score % 6 == 0)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text('Level $_level! 🚀',
                          style: GoogleFonts.outfit(
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w800,
                              fontSize: 22)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBasket() {
    return Container(
      width: _basketW,
      height: _basketH,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Text('🧺',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildStartOverlay() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('✂️', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text('Catch salon tools!',
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
          const SizedBox(height: 6),
          Text('Slide the basket — avoid 🚫 & 💣',
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 6),
          Text('+20 pts per level cleared',
              style: GoogleFonts.outfit(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Game Over!',
                style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 22)),
            const SizedBox(height: 8),
            Text('Score: $_score  •  Level: $_level',
                style: GoogleFonts.outfit(
                    color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 6),
            Text('+$_totalPts pts earned',
                style: GoogleFonts.outfit(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _startGame,
          icon: Icon(_gameOver ? Icons.refresh_rounded : Icons.play_arrow_rounded),
          label: Text(
            _gameOver ? 'Play Again' : 'Start Game',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class _FallingItem {
  double x, y, speed;
  final String emoji;
  final bool isBad;
  _FallingItem({
    required this.x,
    required this.y,
    required this.emoji,
    required this.speed,
    required this.isBad,
  });
}