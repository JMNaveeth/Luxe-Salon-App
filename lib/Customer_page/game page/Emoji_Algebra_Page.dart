import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class EmojiAlgebraPage extends StatefulWidget {
  const EmojiAlgebraPage({super.key});

  @override
  State<EmojiAlgebraPage> createState() => _EmojiAlgebraPageState();
}

class _EmojiAlgebraPageState extends State<EmojiAlgebraPage>
    with SingleTickerProviderStateMixin {
  // ── puzzle bank ───────────────────────────────────────────────────────
  static const _puzzles = [
    _Puzzle(
      emojis: ['💇', '✂️', '💅'],
      clues: [
        _Clue('💇 + 💇', '= 10'),
        _Clue('✂️ + 💇', '= 14'),
        _Clue('💅 × ✂️', '= 20'),
      ],
      question: '💇 + ✂️ + 💅 = ?',
      answer: 18,
      values: {'💇': 5, '✂️': 9, '💅': 4},
      hint: '💇 = 5,  ✂️ = 9,  💅 = 4',
    ),
    _Puzzle(
      emojis: ['🪮', '💆', '🧴'],
      clues: [
        _Clue('🪮 + 🪮', '= 8'),
        _Clue('💆 − 🪮', '= 3'),
        _Clue('🧴 × 💆', '= 49'),
      ],
      question: '🪮 + 💆 + 🧴 = ?',
      answer: 18,
      values: {'🪮': 4, '💆': 7, '🧴': 7},
      hint: '🪮 = 4,  💆 = 7,  🧴 = 7',
    ),
    _Puzzle(
      emojis: ['💈', '🪞', '🧹'],
      clues: [
        _Clue('💈 × 💈', '= 9'),
        _Clue('🪞 + 💈', '= 8'),
        _Clue('🧹 − 🪞', '= 1'),
      ],
      question: '💈 + 🪞 + 🧹 = ?',
      answer: 14,
      values: {'💈': 3, '🪞': 5, '🧹': 6},
      hint: '💈 = 3,  🪞 = 5,  🧹 = 6',
    ),
    _Puzzle(
      emojis: ['🛁', '💋', '🧼'],
      clues: [
        _Clue('🛁 + 🛁', '= 12'),
        _Clue('💋 × 🛁', '= 36'),
        _Clue('🧼 + 💋', '= 11'),
      ],
      question: '🛁 + 💋 + 🧼 = ?',
      answer: 17,
      values: {'🛁': 6, '💋': 6, '🧼': 5},
      hint: '🛁 = 6,  💋 = 6,  🧼 = 5',
    ),
    _Puzzle(
      emojis: ['🌸', '💊', '🎀'],
      clues: [
        _Clue('🌸 + 🌸 + 🌸', '= 15'),
        _Clue('💊 − 🌸', '= 2'),
        _Clue('🎀 × 🌸', '= 35'),
      ],
      question: '🌸 + 💊 + 🎀 = ?',
      answer: 19,
      values: {'🌸': 5, '💊': 7, '🎀': 7},
      hint: '🌸 = 5,  💊 = 7,  🎀 = 7',
    ),
  ];

  // ── state ─────────────────────────────────────────────────────────────
  late _Puzzle _current;
  final _controller = TextEditingController();
  _AnswerState _answerState = _AnswerState.idle;
  bool _hintShown = false;
  int _totalPts = 0;
  int _streak = 0;
  int _puzzleIdx = 0;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnim = CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut);
    _loadPuzzle();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _loadPuzzle({bool next = false}) {
    if (next) {
      _puzzleIdx = (_puzzleIdx + 1) % _puzzles.length;
    } else {
      _puzzleIdx = Random().nextInt(_puzzles.length);
    }
    setState(() {
      _current = _puzzles[_puzzleIdx];
      _controller.clear();
      _answerState = _AnswerState.idle;
      _hintShown = false;
    });
    _bounceCtrl.forward(from: 0);
  }

  void _checkAnswer() {
    final val = int.tryParse(_controller.text.trim());
    if (val == null) return;
    final correct = val == _current.answer;
    setState(() {
      _answerState = correct ? _AnswerState.correct : _AnswerState.wrong;
      if (correct) {
        _streak++;
        final bonus = _streak >= 3 ? 10 : 0;
        _totalPts += 25 + bonus;
      } else {
        _streak = 0;
      }
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFF59E0B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Emoji Algebra',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+$_totalPts pts',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFFF59E0B),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakBar(),
            const SizedBox(height: 16),
            _buildInstructionCard(),
            const SizedBox(height: 20),
            _buildCluesCard(),
            const SizedBox(height: 20),
            _buildQuestionCard(),
            const SizedBox(height: 16),
            _buildAnswerRow(),
            const SizedBox(height: 20),
            _buildFeedback(),
            const SizedBox(height: 20),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakBar() {
    return Row(
      children: [
        const Text('🔥', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(
          'Streak: $_streak',
          style: GoogleFonts.outfit(
            color: _streak >= 3
                ? const Color(0xFFF59E0B)
                : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        if (_streak >= 3) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+10 bonus',
              style: GoogleFonts.outfit(
                color: const Color(0xFFF59E0B),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFF59E0B).withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          const Text('🧮', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Use the clues to find each emoji's value, then solve the final equation.",
              style: GoogleFonts.outfit(
                  color: const Color(0xFF92400E), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCluesCard() {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) => Transform.scale(
        scale: 0.92 + 0.08 * _bounceAnim.value,
        child: child,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clues',
              style: GoogleFonts.outfit(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8),
            ),
            const SizedBox(height: 12),
            ..._current.clues.asMap().entries.map((e) {
              final idx = e.key;
              final clue = e.value;
              final colors = [
                const Color(0xFF7C3AED),
                const Color(0xFF0EA5E9),
                const Color(0xFF10B981),
              ];
              final bgColors = [
                const Color(0xFFF5F3FF),
                const Color(0xFFE0F2FE),
                const Color(0xFFE8F5E9),
              ];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColors[idx % bgColors.length],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        clue.left,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors[idx % colors.length].withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        clue.right,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors[idx % colors.length],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Find the answer',
            style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _current.question,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow() {
    final isCorrect = _answerState == _AnswerState.correct;
    final isWrong = _answerState == _AnswerState.wrong;
    final borderColor = isCorrect
        ? const Color(0xFF10B981)
        : isWrong
            ? const Color(0xFFEF4444)
            : const Color(0xFFF59E0B);

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
              boxShadow: AppColors.cardShadow,
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '?',
                hintStyle: GoogleFonts.outfit(
                    color: AppColors.textMuted, fontSize: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (_) => _checkAnswer(),
              readOnly: isCorrect,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          height: 56,
          child: ElevatedButton(
            onPressed: isCorrect ? null : _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              disabledBackgroundColor:
                  const Color(0xFF10B981).withOpacity(0.8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.send_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    if (_answerState == _AnswerState.idle) return const SizedBox.shrink();

    final isCorrect = _answerState == _AnswerState.correct;
    final streakBonus = isCorrect && _streak >= 3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFEF4444).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            isCorrect ? '🎉 Correct!' : '❌ Not quite...',
            style: GoogleFonts.outfit(
              color: isCorrect
                  ? const Color(0xFF065F46)
                  : const Color(0xFF991B1B),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          if (isCorrect)
            Text(
              '+25 pts earned${streakBonus ? ' (+10 streak bonus!)' : ''}',
              style: GoogleFonts.outfit(
                color: const Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          if (!isCorrect && _hintShown)
            Text(
              _current.hint,
              style: GoogleFonts.outfit(
                color: const Color(0xFF991B1B),
                fontSize: 13,
              ),
            ),
          if (!isCorrect && !_hintShown)
            TextButton(
              onPressed: () => setState(() => _hintShown = true),
              child: Text(
                'Show hint',
                style: GoogleFonts.outfit(
                    color: const Color(0xFFF59E0B),
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _loadPuzzle(),
            icon: const Icon(Icons.shuffle_rounded, size: 18),
            label: Text('New puzzle',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF59E0B),
              side: const BorderSide(color: Color(0xFFF59E0B), width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        if (_answerState == _AnswerState.correct) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _loadPuzzle(next: true),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text('Next',
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Data models ───────────────────────────────────────────────────────────
enum _AnswerState { idle, correct, wrong }

class _Puzzle {
  final List<String> emojis;
  final List<_Clue> clues;
  final String question;
  final int answer;
  final Map<String, int> values;
  final String hint;

  const _Puzzle({
    required this.emojis,
    required this.clues,
    required this.question,
    required this.answer,
    required this.values,
    required this.hint,
  });
}

class _Clue {
  final String left, right;
  const _Clue(this.left, this.right);
}