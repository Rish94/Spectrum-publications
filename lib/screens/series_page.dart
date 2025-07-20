import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/models/series.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/screens/classes_page.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';

class SeriesPage extends StatefulWidget {
  final String? initialLanguage;

  const SeriesPage({
    super.key,
    this.initialLanguage,
  });

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final ApiService _apiService = ApiService();
  List<Series> _series = [];
  bool _isLoading = true;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage ?? 'English';
    _loadSeries();
  }

  @override
  void didUpdateWidget(SeriesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLanguage != oldWidget.initialLanguage && widget.initialLanguage != null) {
      setState(() {
        _selectedLanguage = widget.initialLanguage!;
      });
      _loadSeries();
    }
  }

  Future<void> _loadSeries() async {
    if (!mounted) return;

    // Clear data and set loading state
    setState(() {
      _isLoading = true;
      _series = [];
      _error = null;
    });

    try {
      final seriesData = await _apiService.getSeriesByMedium(_selectedLanguage);
      if (!mounted) return;

      setState(() {
        _series = seriesData.map((data) => Series.fromJson(data)).toList();
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/series'),
      appBar: CustomAppBar(
        title: '$_selectedLanguage Series',
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
              [
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
                              onPressed: _loadSeries,
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
                  : _series.isEmpty
                      ? const Center(
                          child: Text(
                            'No series found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              GridView.builder(
                                padding: const EdgeInsets.all(16),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: _series.length,
                                itemBuilder: (context, index) {
                                  final series = _series[index];
                                  return GestureDetector(
                                    onTap: () => context.go(
                                      '/series/${series.id}/options?name=${Uri.encodeComponent(series.name)}&isHindi=${_selectedLanguage == 'Hindi'}',
                                    ),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: index % 2 == 0
                                                ? [
                                                    const Color(0xFF1A237E),
                                                    const Color(0xFF0D47A1),
                                                  ]
                                                : [
                                                    const Color(0xFF4A148C),
                                                    const Color(0xFF311B92),
                                                  ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                              child: series.imageUrl != null &&
                                                      series.imageUrl!.startsWith('http')
                                                  ? Image.network(
                                                      series.imageUrl!,
                                                      fit: BoxFit.contain,
                                                      loadingBuilder:
                                                          (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return Container(
                                                          decoration: ThemeHelper
                                                              .getPlaceholderDecoration(),
                                                          child: Center(
                                                            child: BookLoader(
                                                              size: 30,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          decoration: ThemeHelper
                                                              .getPlaceholderDecoration(),
                                                          child: Image.asset(
                                                            'assets/books.jpg',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Image.asset(
                                                      'assets/books.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.1),
                                                  borderRadius: const BorderRadius.vertical(
                                                    bottom: Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          series.name,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            letterSpacing: 0.5,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        if (series.description != null) ...[
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            series.description!,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.white.withOpacity(0.8),
                                                              height: 1.2,
                                                            ),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 10, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                            Icons.arrow_forward_rounded,
                                                            color: Colors.white,
                                                            size: 14,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                              color: Colors.white.withOpacity(0.9),
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
}
