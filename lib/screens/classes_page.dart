import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/models/class_model.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';

class ClassesPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final String contentType;
  final bool isHindi;
  final String typeId;

  const ClassesPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
    required this.contentType,
    this.isHindi = false,
    required this.typeId,
  });

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final ApiService _apiService = ApiService();
  List<ClassModel> _classes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _classes = [];
      _error = null;
    });

    try {
      final classesData = await _apiService.getClassesBySeries(widget.seriesId);
      if (!mounted) return;

      setState(() {
        _classes = classesData.map((data) => ClassModel.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/series'),
      appBar: CustomAppBar(
        title: '${widget.seriesName} - Classes',
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
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
                              onPressed: _loadClasses,
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
                  : _classes.isEmpty
                      ? const Center(
                          child: Text(
                            'No classes found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: _classes.map((classItem) {
                                    return Column(
                                      children: [
                                        _buildClassCard(
                                          context: context,
                                          classItem: classItem,
                                          onTap: () => context.push(
                                            '/series/${widget.seriesId}/classes/${classItem.id}/subjects?name=${Uri.encodeComponent(widget.seriesName)}&className=${Uri.encodeComponent(classItem.name)}&contentType=${widget.contentType}&isHindi=${widget.isHindi}&typeId=${widget.typeId}',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  }).toList(),
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
    );
  }

  Widget _buildClassCard({
    required BuildContext context,
    required ClassModel classItem,
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
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF4158D0).withOpacity(0.2),
                      const Color(0xFFC850C0).withOpacity(0.1),
                    ]
                  : [
                      const Color(0xFF4158D0),
                      const Color(0xFFC850C0),
                    ],
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
                    color: const Color(0xFF4158D0).withOpacity(0.1),
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
                    color: const Color(0xFFC850C0).withOpacity(0.1),
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
                                : const Color(0xFF4158D0).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.class_,
                        size: 32,
                        color: Color(0xFF4158D0),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${classItem.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Subjects',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4158D0),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFF4158D0),
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
    );
  }
}
