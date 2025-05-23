import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PdfCacheManager {
  static final PdfCacheManager _instance = PdfCacheManager._internal();
  factory PdfCacheManager() => _instance;
  PdfCacheManager._internal();

  // Memory cache to store loaded PDFs
  final Map<String, File> _memoryCache = {};
  static const int _maxMemoryCacheSize = 5; // Keep last 5 PDFs in memory
  final List<String> _recentlyAccessed = [];

  // Get the application documents directory for persistent storage
  Future<Directory> get _appDocumentsDir async {
    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${dir.path}/pdf_cache');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }
    return pdfDir;
  }

  Future<File> getCachedFile(String url) async {
    // Check memory cache first
    if (_memoryCache.containsKey(url)) {
      _updateRecentlyAccessed(url);
      return _memoryCache[url]!;
    }

    // Check persistent storage
    final pdfDir = await _appDocumentsDir;
    final fileName = md5.convert(utf8.encode(url)).toString() + '.pdf';
    final file = File('${pdfDir.path}/$fileName');

    if (await file.exists()) {
      // Add to memory cache if there's space
      if (_memoryCache.length < _maxMemoryCacheSize) {
        _memoryCache[url] = file;
        _updateRecentlyAccessed(url);
      }
      return file;
    }

    // Download and cache
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);

      // Add to memory cache if there's space
      if (_memoryCache.length < _maxMemoryCacheSize) {
        _memoryCache[url] = file;
        _updateRecentlyAccessed(url);
      }
      return file;
    }

    throw Exception('Failed to download PDF');
  }

  void _updateRecentlyAccessed(String url) {
    _recentlyAccessed.remove(url);
    _recentlyAccessed.add(url);

    // If we exceed memory cache size, remove least recently used
    if (_memoryCache.length > _maxMemoryCacheSize) {
      final oldestUrl = _recentlyAccessed.first;
      _memoryCache.remove(oldestUrl);
      _recentlyAccessed.removeAt(0);
    }
  }

  // Method to preload PDFs
  Future<void> preloadPdf(String url) async {
    if (!_memoryCache.containsKey(url)) {
      try {
        await getCachedFile(url);
      } catch (e) {
        print('Failed to preload PDF: $e');
      }
    }
  }

  // Method to clear memory cache if needed
  void clearMemoryCache() {
    _memoryCache.clear();
    _recentlyAccessed.clear();
  }

  // Method to get cache size
  Future<int> getCacheSize() async {
    final pdfDir = await _appDocumentsDir;
    int totalSize = 0;

    await for (final file in pdfDir.list()) {
      if (file is File) {
        totalSize += await file.length();
      }
    }

    return totalSize;
  }

  // Method to clear old cache files if cache size exceeds limit
  Future<void> clearOldCacheIfNeeded() async {
    const maxCacheSize = 100 * 1024 * 1024; // 100 MB limit
    final currentSize = await getCacheSize();

    if (currentSize > maxCacheSize) {
      final pdfDir = await _appDocumentsDir;
      final files = await pdfDir.list().toList();

      // Sort files by last modified time
      files.sort((a, b) {
        return a.statSync().modified.compareTo(b.statSync().modified);
      });

      // Remove oldest files until we're under the limit
      for (final file in files) {
        if (file is File) {
          await file.delete();
          final newSize = await getCacheSize();
          if (newSize <= maxCacheSize) break;
        }
      }
    }
  }
}
