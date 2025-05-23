import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/components/books/book_card.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/models/book.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/services/api_service.dart';
import 'package:spectrum_app/components/books/pdf_cache_manager.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';

class BooksPage extends StatefulWidget {
  final String seriesId;
  final String seriesName;
  final String classId;
  final String className;

  const BooksPage({
    super.key,
    required this.seriesId,
    required this.seriesName,
    required this.classId,
    required this.className,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final ApiService _apiService = ApiService();
  final PdfCacheManager _pdfCacheManager = PdfCacheManager();
  List<Book> _books = [];
  bool _isLoading = true;
  String? _error;
  final String _searchQuery = '';
  final String _sortBy = 'name';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final booksData = await _apiService.getBooksOfClass(
        widget.seriesId,
        widget.classId,
      );
      setState(() {
        _books = booksData.map((data) => Book.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Book> get _filteredBooks {
    return _books.where((book) {
      final searchLower = _searchQuery.toLowerCase();
      return book.name.toLowerCase().contains(searchLower) ||
          (book.description?.toLowerCase().contains(searchLower) ?? false);
    }).toList()
      ..sort((a, b) {
        switch (_sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'rate':
            final rateA = double.tryParse(a.rate) ?? 0.0;
            final rateB = double.tryParse(b.rate) ?? 0.0;
            return rateB.compareTo(rateA);
          default:
            return 0;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          isDarkMode ? colorScheme.surface : Colors.white.withOpacity(0.95),
      endDrawer: const AppDrawer(currentRoute: '/books'),
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: isDarkMode ? colorScheme.surface : colorScheme.primary,
        foregroundColor: isDarkMode ? colorScheme.onSurface : Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Books',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Discover our collection of educational books designed to help students excel in their studies.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildBooksGrid(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksGrid(ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(
        child: BookLoader(color: colorScheme.primary),
      );
    }

    if (_error != null) {
      return Container(
        // padding: const EdgeInsets.all(24),
        // margin: const EdgeInsets.all(16),
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
      );
    }

    if (_filteredBooks.isEmpty) {
      return Container(
        // padding: const EdgeInsets.all(24),
        // margin: const EdgeInsets.all(16),
        decoration: ThemeHelper.getCardDecoration(
          gradientColors: ThemeHelper.secondaryGradient,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.book_outlined,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No books found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'No books available for this class'
                  : 'No books match your search',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.48,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredBooks.length,
      itemBuilder: (context, index) {
        final book = _filteredBooks[index];
        return BookCard(
          book: book,
          isPdfLoading: false,
          onPdfTap: book.pdfUrl != null
              ? () async {
                  final cachedFile =
                      await _pdfCacheManager.getCachedFile(book.pdfUrl!);
                  if (mounted) {
                    context.push('/pdf-viewer', extra: cachedFile);
                  }
                }
              : null,
          onVideoTap: book.videoUrl != null
              ? () {
                  // Navigate to video player
                }
              : null,
        );
      },
    );
  }
}
