import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Earnings',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF0F0E0A)),
      home: const DailyEarningsScreen(),
    );
  }
}

// --- Data Model ---
class EarningItem {
  final String amount;
  final String title;
  final String subtitle;
  final String timeAgo;

  const EarningItem({
    required this.amount,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });
}

// --- Main Screen ---
class DailyEarningsScreen extends StatefulWidget {
  const DailyEarningsScreen({super.key});

  @override
  State<DailyEarningsScreen> createState() => _DailyEarningsScreenState();
}

class _DailyEarningsScreenState extends State<DailyEarningsScreen> {
  int _selectedNavIndex = 0;

  final List<EarningItem> _recentItems = const [
    EarningItem(
      amount: '\$180',
      title: 'Royal Signature Haircut',
      subtitle: 'Payment Successful',
      timeAgo: '10 mins ago',
    ),
    EarningItem(
      amount: '\$320',
      title: 'Full Gold Facial Spa',
      subtitle: 'Payment Successful',
      timeAgo: '45 mins ago',
    ),
    EarningItem(
      amount: '\$95',
      title: 'Beard Sculpting',
      subtitle: 'Payment Successful',
      timeAgo: '1 hour ago',
    ),
    EarningItem(
      amount: '\$450',
      title: 'Elite Full Service',
      subtitle: 'Payment Successful',
      timeAgo: '2 hours ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E0A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _AppBar(),
                    const SizedBox(height: 28),
                    _TodaysTotalCard(),
                    const SizedBox(height: 16),
                    _StatsRow(),
                    const SizedBox(height: 28),
                    _RecentMoneyInHeader(),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentItems.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) =>
                          _EarningCard(item: _recentItems[i]),
                    ),
                    const SizedBox(height: 28),
                    _WithdrawButton(),
                    const SizedBox(height: 12),
                    _DownloadReportButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

// --- App Bar ---
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo icon
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF252410),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF3A3820)),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: Color(0xFFD4A843),
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Daily Earnings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE8E8E8),
            fontFamily: 'Georgia',
          ),
        ),
        const Spacer(),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1910),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: const Color(0xFF2E2D1A)),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF888877),
            size: 18,
          ),
        ),
      ],
    );
  }
}

// --- Today's Total Card ---
class _TodaysTotalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E2D1A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A843).withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "TODAY'S TOTAL",
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2.5,
              color: Color(0xFF888877),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Piggy bank icon
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF252410),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.savings_outlined,
                    color: Color(0xFFD4A843),
                    size: 20,
                  ),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFE8D4A0), Color(0xFFD4A843)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  '\$1,240',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2E1A),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded,
                    color: Color(0xFF4CAF50), size: 14),
                SizedBox(width: 5),
                Text(
                  '+15% from yesterday',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Stats Row ---
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            icon: Icons.attach_money_rounded,
            label: 'THIS WEEK',
            value: '\$8,420',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            icon: Icons.sync_alt_rounded,
            label: 'AVG. SALE',
            value: '\$145',
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF252410),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFD4A843), size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  color: Color(0xFF666655),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE8E8E8),
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}

// --- Recent Money In Header ---
class _RecentMoneyInHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2E1A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_downward_rounded,
                  color: Color(0xFF4CAF50), size: 14),
            ),
            const SizedBox(width: 8),
            const Text(
              'Recent Money In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE8E8E8),
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'VIEW ALL',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4A843),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Earning Card ---
class _EarningCard extends StatelessWidget {
  final EarningItem item;

  const _EarningCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1910),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2D1A)),
      ),
      child: Row(
        children: [
          // Amount box
          Container(
            width: 62,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF252410),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF3A3820)),
            ),
            child: Center(
              child: Text(
                item.amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD4A843),
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8E8E8),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF666655),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Time ago
          Text(
            item.timeAgo,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF555544),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

// --- Withdraw Button ---
class _WithdrawButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4A843), Color(0xFFB8861F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4A843).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'WITHDRAW DAILY FUNDS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Color(0xFF0A0A0A),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Download Report Button ---
class _DownloadReportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1910),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2E2D1A)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_outlined,
                color: Color(0xFF888877), size: 16),
            SizedBox(width: 8),
            Text(
              "Download Today's Report",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888877),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Bottom Nav Bar ---
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    {'icon': Icons.home_outlined, 'label': 'HOME'},
    {'icon': Icons.calendar_today_outlined, 'label': 'BOOKINGS'},
    {'icon': Icons.people_outline, 'label': 'CLIENTS'},
    {'icon': Icons.settings_outlined, 'label': 'SETTINGS'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF111109),
        border: Border(top: BorderSide(color: Color(0xFF222215))),
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _items[i]['icon'] as IconData,
                    size: 20,
                    color: selected
                        ? const Color(0xFFD4A843)
                        : const Color(0xFF444433),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFFD4A843)
                          : const Color(0xFF444433),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4A843),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}