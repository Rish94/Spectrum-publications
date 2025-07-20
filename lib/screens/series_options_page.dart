import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/models/content_type.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';

class SeriesOptionsPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final bool isHindi;

  const SeriesOptionsPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
    this.isHindi = false,
  });

  @override
  State<SeriesOptionsPage> createState() => _SeriesOptionsPageState();
}

class _SeriesOptionsPageState extends State<SeriesOptionsPage> {
  final ApiService _apiService = ApiService();
  List<ContentType> _contentTypes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContentTypes();
  }

  Future<void> _loadContentTypes() async {
    setState(() {
      _isLoading = true;
      _contentTypes = [];
      _error = null;
    });

    try {
      final typesData = await _apiService.getContentTypes();
      if (!mounted) return;

      setState(() {
        _contentTypes =
            typesData.map((data) => ContentType.fromJson(data)).toList();
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
        title: '${widget.seriesName} - Options',
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
                              onPressed: _loadContentTypes,
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: _contentTypes.map((type) {
                                return Column(
                                  children: [
                                    _buildOptionCard(
                                      context: context,
                                      contentType: type,
                                      onTap: () => context.push(
                                        '/series/${widget.seriesId}/classes?name=${Uri.encodeComponent(widget.seriesName)}&contentType=${type.contentType.toLowerCase()}&isHindi=${widget.isHindi}&typeId=${type.id}',
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

  Widget _buildOptionCard({
    required BuildContext context,
    required ContentType contentType,
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
                      contentType.getGradient()[0].withOpacity(0.2),
                      contentType.getGradient()[1].withOpacity(0.1),
                    ]
                  : contentType.getGradient(),
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
                    color: contentType.getGradient()[0].withOpacity(0.1),
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
                    color: contentType.getGradient()[1].withOpacity(0.1),
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
                                : contentType.getGradient()[0].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        contentType.getIcon(),
                        size: 32,
                        color: contentType.getGradient()[0],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      contentType.typeName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (contentType.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        contentType.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black54,
                        ),
                      ),
                    ],
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
                            'View Content',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: contentType.getGradient()[0],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: contentType.getGradient()[0],
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
