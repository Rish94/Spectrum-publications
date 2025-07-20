import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/text_style.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/screens/series_page.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/screens/classes_page.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> temp = [
    "assets/image1.jpg",
    "assets/image2.jpg",
    "assets/image3.jpg",
    "assets/image4.jpg"
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // List of engaging colors for cards
  final List<Color> _cardColors = [
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFF9C27B0), // Purple
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Pink
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF795548), // Brown
    const Color(0xFF009688), // Teal
    const Color(0xFF3F51B5), // Indigo
  ];

  // List of engaging icons for series
  final List<IconData> _seriesIcons = [
    Icons.school_rounded,
    Icons.menu_book_rounded,
    Icons.auto_stories_rounded,
    Icons.calculate_rounded,
    Icons.science_rounded,
    Icons.computer_rounded,
    Icons.palette_rounded,
    Icons.music_note_rounded,
    Icons.sports_soccer_rounded,
    Icons.history_edu_rounded,
  ];

  // Add new color schemes for cards
  final List<List<Color>> _cardGradients = [
    [
      const Color(0xFF1A237E),
      const Color(0xFF0D47A1)
    ], // Deep Indigo to Deep Blue for Hindi
    [
      const Color(0xFF4A148C),
      const Color(0xFF311B92)
    ], // Deep Purple to Deep Indigo for English
    [const Color(0xFFFFD93D), const Color(0xFFFFE66D)], // Yellow
    [const Color(0xFF95E1D3), const Color(0xFFEAFFD0)], // Mint
    [const Color(0xFFFF8B94), const Color(0xFFFFAAA5)], // Pink
  ];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Color _getRandomColor(String seriesName) {
    final seed = seriesName.codeUnits.reduce((a, b) => a + b);
    final random = Random(seed);
    return _cardColors[random.nextInt(_cardColors.length)];
  }

  IconData _getRandomIcon(String seriesName) {
    final seed = seriesName.codeUnits.reduce((a, b) => a + b);
    final random = Random(seed);
    return _seriesIcons[random.nextInt(_seriesIcons.length)];
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            isDarkMode ? const Color(0xFF1A1A1A) : colorScheme.background,
        endDrawer: const AppDrawer(currentRoute: '/'),
        body: Stack(
          children: [
            // Enhanced background with more playful elements
            Positioned.fill(
              child: CustomPaint(
                painter: EnhancedBackgroundPainter(isDarkMode: isDarkMode),
              ),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDarkMode
                                ? [Colors.blue.shade400, Colors.purple.shade300]
                                : [
                                    Colors.purple.shade900,
                                    Colors.blue.shade900
                                  ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        child: CustomPaint(
                          painter: EnhancedWavePainter(isDarkMode: isDarkMode),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          CarouselSlider(
                            items: temp
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.asset(
                                          item,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                              height: 320,
                              autoPlay: true,
                              aspectRatio: 8 / 3,
                              viewportFraction: 0.7,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlayInterval: const Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: _buildAnimatedCard(
                            title: "Hindi",
                            subtitle: "Digital Books",
                            gradient: _cardGradients[0],
                            icon: Icons.menu_book_rounded,
                            onTap: () => context.go('/series?language=Hindi'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAnimatedCard(
                            title: "English",
                            subtitle: "Digital View",
                            gradient: _cardGradients[1],
                            icon: Icons.auto_stories_rounded,
                            onTap: () => context.go('/series?language=English'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const FooterCard(),
                  const SizedBox(height: 50),
                ],
              ),
            ),

            // Enhanced header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [Colors.blue.shade400, Colors.purple.shade300]
                        : [Colors.purple.shade900, Colors.blue.shade900],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "Good Evening, Students",
                      style: Text_Style.large().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Image.asset(
                            "assets/books.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Text_Style.large().copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                Text(
                  subtitle,
                  style: Text_Style.small(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Tap to View",
                    style: Text_Style.small(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isDarkMode ? 2 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      gradient[0].withOpacity(0.2),
                      gradient[1].withOpacity(0.1),
                    ]
                  : gradient,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gradient[0].withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gradient[1].withOpacity(0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : gradient[0].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: gradient[0],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnhancedBackgroundPainter extends CustomPainter {
  final bool isDarkMode;

  EnhancedBackgroundPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw base background
    final basePaint = Paint()
      ..color = isDarkMode
          ? Colors.purple.withOpacity(0.05)
          : Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, basePaint);

    // Draw decorative elements
    final circlePaint = Paint()
      ..color = isDarkMode
          ? Colors.purple.withOpacity(0.1)
          : Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating circles
    for (var i = 0; i < 15; i++) {
      final x = Random().nextDouble() * size.width;
      final y = Random().nextDouble() * size.height;
      final radius = Random().nextDouble() * 40 + 10;
      canvas.drawCircle(Offset(x, y), radius, circlePaint);
    }

    // Draw stars
    final starPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 20; i++) {
      final x = Random().nextDouble() * size.width;
      final y = Random().nextDouble() * size.height;
      _drawStar(canvas, Offset(x, y), 5, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 2 * pi / 5) - pi / 2;
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EnhancedWavePainter extends CustomPainter {
  final bool isDarkMode;

  EnhancedWavePainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw multiple waves
    for (var i = 0; i < 3; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.7 + i * 0.1));

      for (var x = 0.0; x <= size.width; x += 50) {
        path.quadraticBezierTo(
          x + 25,
          size.height * (0.7 + i * 0.1) + (i % 2 == 0 ? 20 : -20),
          x + 50,
          size.height * (0.7 + i * 0.1),
        );
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
