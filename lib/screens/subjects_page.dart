import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';
import 'package:spectrum_app/models/subject_model.dart';
import 'package:spectrum_app/services/api_service.dart';

class SubjectsPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final String classId;
  final String className;
  final String contentType; // 'ebooks', 'videos', or 'exam-papers'
  final bool isHindi;
  final String typeId;

  const SubjectsPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
    required this.classId,
    required this.className,
    required this.contentType,
    this.isHindi = false,
    required this.typeId,
  });

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // List of beautiful gradients for subject cards
  final List<List<Color>> _gradients = [
    [Color(0xFF4158D0), Color(0xFFC850C0), Color(0xFFFFCC70)],
    [Color(0xFF0093E9), Color(0xFF80D0C7)],
    [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
    [Color(0xFFA9C9FF), Color(0xFFFFBBEC)],
    [Color(0xFFD4FC79), Color(0xFF96E6A1)],
    [Color(0xFF84FAB0), Color(0xFF8FD3F4)],
    [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
    [Color(0xFFFF9A8B), Color(0xFFFF6A88), Color(0xFFFF99AC)],
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadSubjects();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    setState(() {
      _isLoading = true;
      _subjects = [];
      _error = null;
    });

    try {
      final subjectsData =
          await _apiService.getSubjectsBySeries(widget.seriesId);
      if (!mounted) return;

      setState(() {
        _subjects =
            subjectsData.map((data) => SubjectModel.fromJson(data)).toList();
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String get _pageTitle {
    switch (widget.contentType) {
      case 'ebooks':
        return 'E-Books';
      case 'videos':
        return 'Video Lectures';
      case 'exam-papers':
        return 'Exam Papers';
      default:
        return 'Subjects';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/subjects'),
      appBar: CustomAppBar(
        title:
            '${widget.className} - ${widget.contentType.replaceAll('-', ' ').toUpperCase()}',
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Colors.white,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: ThemeHelper.getGradient(
              isDarkMode
                  ? [
                      const Color(0xFF1A1A1A),
                      const Color(0xFF2C2C2C),
                    ]
                  : [
                      colorScheme.background,
                      colorScheme.background.withOpacity(0.95),
                    ],
              isVertical: true,
            ),
          ),
          child: _isLoading
              ? const Center(
                  child: BookLoader(),
                )
              : _error != null
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.all(16),
                        decoration: ThemeHelper.getCardDecoration(
                          gradientColors: ThemeHelper.errorGradient,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadSubjects,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _subjects.isEmpty
                      ? const Center(
                          child: Text(
                            'No subjects found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: _subjects.length,
                                    itemBuilder: (context, index) {
                                      final subject = _subjects[index];
                                      return _buildSubjectCard(
                                        context: context,
                                        subject: subject,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 32),
                                const FooterCard(),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard({
    required BuildContext context,
    required SubjectModel subject,
    required int index,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final gradient = _gradients[index % _gradients.length];

    return Hero(
      tag: 'subject-${subject.id}',
      child: Card(
        elevation: isDarkMode ? 2 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => context.push(
            '/series/${widget.seriesId}/classes/${widget.classId}/subjects/${subject.id}/books?name=${Uri.encodeComponent(widget.seriesName)}&className=${Uri.encodeComponent(widget.className)}&subjectName=${Uri.encodeComponent(subject.name)}&contentType=${widget.contentType}&isHindi=${widget.isHindi}&typeId=${widget.typeId}',
          ),
          borderRadius: BorderRadius.circular(20),
          child: Container(
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                          _getSubjectIcon(subject.name),
                          size: 28,
                          color: gradient[0],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        subject.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: gradient[0],
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 10,
                              color: gradient[0],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subjectName) {
    final lowerName = subjectName.toLowerCase();
    if (lowerName.contains('math') ||
        lowerName.contains('algebra') ||
        lowerName.contains('calculus')) {
      return Icons.calculate;
    } else if (lowerName.contains('science') ||
        lowerName.contains('physics') ||
        lowerName.contains('chemistry') ||
        lowerName.contains('biology')) {
      return Icons.science;
    } else if (lowerName.contains('english') ||
        lowerName.contains('literature')) {
      return Icons.menu_book;
    } else if (lowerName.contains('history')) {
      return Icons.history_edu;
    } else if (lowerName.contains('geography')) {
      return Icons.public;
    } else if (lowerName.contains('computer') ||
        lowerName.contains('programming')) {
      return Icons.computer;
    } else if (lowerName.contains('art') || lowerName.contains('drawing')) {
      return Icons.palette;
    } else if (lowerName.contains('music')) {
      return Icons.music_note;
    } else if (lowerName.contains('sports') || lowerName.contains('physical')) {
      return Icons.sports_soccer;
    } else {
      return Icons.school;
    }
  }
}
