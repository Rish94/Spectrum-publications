import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/books/book_card.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/models/book_model.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/components/books/pdf_cache_manager.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:spectrum_app/components/footer_card.dart';
import 'package:spectrum_app/config/api_config.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class BooksPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final String classId;
  final String className;
  final String subjectId;
  final String subjectName;
  final String contentType;
  final String typeId;

  const BooksPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.contentType,
    required this.typeId,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final ApiService _apiService = ApiService();
  List<BookModel> _books = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _books = [];
      _error = null;
    });

    try {
      final booksData = await _apiService.getBooksByClassAndType(
        widget.classId,
        widget.typeId,
      );
      if (!mounted) return;

      setState(() {
        _books = booksData.map((data) => BookModel.fromJson(data)).toList();
        _isLoading = false;
      });

      print(booksData);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleBookTap(BookModel book) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final file = book.bookFiles.firstOrNull;
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No content available for this book'),
          backgroundColor: isDarkMode ? Colors.red[900] : Colors.red,
        ),
      );
      return;
    }

    // Check if there's an external link
    if (file.link != null && file.link!.isNotEmpty) {
      // Launch external link in browser
      launchUrl(
        Uri.parse(file.link!),
        mode: LaunchMode.externalApplication,
      ).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: $error'),
            backgroundColor: isDarkMode ? Colors.red[900] : Colors.red,
          ),
        );
      });
      return;
    }

    // Handle base path content
    final filePath = file.getFilePath();
    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No file path available for this book'),
          backgroundColor: isDarkMode ? Colors.red[900] : Colors.red,
        ),
      );
      return;
    }

    if (file.isPdf) {
      print(filePath);
      context.push('/pdf-viewer', extra: filePath);
    } else if (file.isVideo) {
      context.push('/video-player', extra: filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unsupported content type'),
          backgroundColor: isDarkMode ? Colors.red[900] : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/books'),
      appBar: CustomAppBar(
        title:
            '${widget.subjectName} - ${widget.contentType.replaceAll('-', ' ').toUpperCase()}',
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
                              onPressed: _loadBooks,
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
                  : _books.isEmpty
                      ? const Center(
                          child: Text(
                            'No books found',
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
                                  children: _books.map((book) {
                                    return Column(
                                      children: [
                                        _buildBookCard(
                                          context: context,
                                          book: book,
                                          onTap: () => _handleBookTap(book),
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

  Widget _buildBookCard({
    required BuildContext context,
    required BookModel book,
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
                child: Row(
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
                      child: Icon(
                        book.bookFiles.firstOrNull?.isPdf ?? false
                            ? Icons.menu_book
                            : Icons.video_library,
                        size: 32,
                        color: const Color(0xFF4158D0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${book.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            'View',
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
