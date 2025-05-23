import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/models/class.dart' as class_model;
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/screens/books_page.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:go_router/go_router.dart';

class ClassesPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;

  const ClassesPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
  });

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final ApiService _apiService = ApiService();
  List<class_model.Class> _classes = [];
  bool _isLoading = true;
  String? _error;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classesData = await _apiService.getClassesOfSeries(widget.seriesId);
      setState(() {
        _classes = classesData
            .map((data) => class_model.Class.fromJson(data))
            .toList();
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
      endDrawer: const AppDrawer(currentRoute: '/classes'),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ThemeHelper.getGradient(ThemeHelper.secondaryGradient),
          ),
        ),
        title: Text(
          widget.seriesName,
          style: const TextStyle(
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
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _classes.length,
                    itemBuilder: (context, index) {
                      final classItem = _classes[index];
                      return GestureDetector(
                        onTap: () => context.go(
                          '/series/${widget.seriesId}/classes/${classItem.id}/books',
                          extra: {
                            'seriesName': widget.seriesName,
                            'className': classItem.name,
                          },
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
                                    child: classItem.imageUrl != null
                                        ? Image.network(
                                            classItem.imageUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            decoration: ThemeHelper
                                                .getPlaceholderDecoration(),
                                            child: Icon(
                                              Icons.school,
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
                                          classItem.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (classItem.description != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            classItem.description!,
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
