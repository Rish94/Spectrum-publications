import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/models/series.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/screens/classes_page.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:go_router/go_router.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final ApiService _apiService = ApiService();
  List<Series> _series = [];
  bool _isLoading = true;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadSeries();
  }

  Future<void> _loadSeries() async {
    try {
      final seriesData = await _apiService.getAllSeries();
      setState(() {
        _series = seriesData.map((data) => Series.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/series'),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeHelper.getGradient(ThemeHelper.accentGradient),
          ),
        ),
        title: const Text(
          'Select Series',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.verified_user, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      body: Container(
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
            ? Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
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
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          '/series/${series.id}/classes',
                          extra: {'name': series.name},
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: ThemeHelper.getCardDecoration(
                              gradientColors: index % 2 == 0
                                  ? ThemeHelper.primaryGradient
                                  : ThemeHelper.accentGradient,
                              isVertical: true,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: series.imageUrl != null
                                        ? Image.network(
                                            series.imageUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            decoration: ThemeHelper
                                                .getPlaceholderDecoration(),
                                            child: Icon(
                                              Icons.book,
                                              size: 50,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          series.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (series.description != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            series.description!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
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
      ),
    );
  }
}
