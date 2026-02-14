import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:spectrum_app/components/books/sound_manager.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:spectrum_app/config/api_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import 'pdf_file_io_stub.dart' if (dart.library.io) 'pdf_file_io.dart' as pdf_file_io;

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  const PdfViewer({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer>
    with TickerProviderStateMixin {
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  String? _userMessage;
  bool _isError = false;
  bool _isWebMode = false;
  double _downloadProgress = 0.0;
  String? _localPdfPath;
  final SoundManager _soundManager = SoundManager();
  late AnimationController _animationController;
  late Animation<double> _pageAnimation;
  late AnimationController _downloadAnimController;
  late Animation<double> _downloadBounceAnimation;
  bool _isForward = true;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    contentType: ApiConfig.contentType,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
  ));

  @override
  void initState() {
    super.initState();
    _soundManager.initialize();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _downloadAnimController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _downloadBounceAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(
        parent: _downloadAnimController,
        curve: Curves.easeInOut,
      ),
    );
    _loadPdf();
  }

  /// Returns a short, user-friendly message. Never exposes raw exceptions or status codes.
  String _userFriendlyMessage(dynamic e) {
    final message = e.toString();

    // Any network/connection/API failure → "Network error"
    if (e is DioException) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null && statusCode >= 400) return 'Network error';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return 'Network error';
        default:
          return 'Network error';
      }
    }
    if (message.contains('SocketException') ||
        message.contains('Connection') ||
        message.contains('connection') ||
        message.contains('Network')) {
      return 'Network error';
    }

    if (message.contains('MissingPluginException') ||
        message.contains('path_provider') ||
        message.contains('getTemporaryDirectory')) {
      return 'Please open the app on your phone or tablet to view PDFs.';
    }
    return 'Something went wrong. Please try again.';
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _userMessage = null;
      _downloadProgress = 0.0;
      _isWebMode = false;
    });

    if (kIsWeb) {
      setState(() {
        _isWebMode = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = widget.pdfUrl.split('/').last;
      if (fileName.isEmpty) throw Exception('Invalid PDF URL');
      final localPath = '${tempDir.path}/$fileName';

      await _dio.download(
        widget.pdfUrl,
        localPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _localPdfPath = localPath;
        _isLoading = false;
        _downloadProgress = 1.0;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userMessage = _userFriendlyMessage(e);
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openPdfInBrowser() async {
    final uri = Uri.tryParse(widget.pdfUrl);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        setState(() {
          _userMessage = 'Could not open the link. Please try again.';
          _isError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _downloadAnimController.dispose();
    _soundManager.dispose();
    _animationController.dispose();
    pdf_file_io.deletePdfFile(_localPdfPath);
    super.dispose();
  }

  void _playPageTurnAnimation(bool isForward) {
    _isForward = isForward;
    _animationController.forward(from: 0.0);
    _soundManager.playPageTurnSound();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : colorScheme.surface,
      appBar: CustomAppBar(
        title: _isLoading
            ? 'Loading PDF…'
            : _isWebMode
                ? 'PDF'
                : 'Page $_currentPage of $_totalPages',
      ),
      body: _buildBody(isDarkMode, colorScheme),
    );
  }

  Widget _buildBody(bool isDarkMode, ColorScheme colorScheme) {
    if (_isWebMode) {
      return _buildWebOpenInBrowser(isDarkMode, colorScheme);
    }
    if (_isLoading) {
      return _buildLoadingState(isDarkMode, colorScheme);
    }
    if (_isError && _userMessage != null) {
      return _buildErrorState(isDarkMode, colorScheme);
    }
    if (_localPdfPath != null) {
      return _buildPdfContent(isDarkMode, colorScheme);
    }
    return _buildLoadingState(isDarkMode, colorScheme);
  }

  Widget _buildWebOpenInBrowser(bool isDarkMode, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 80,
              color: colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 24),
            Text(
              'View PDF in browser',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'PDF viewing is not available here. Open the link in your browser to read.',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode
                    ? Colors.white70
                    : colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _openPdfInBrowser,
              icon: const Icon(Icons.open_in_browser_rounded),
              label: const Text('Open in browser'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode, ColorScheme colorScheme) {
    final isDownloading = _downloadProgress > 0 && _downloadProgress < 1;
    final primary = colorScheme.primary;
    final onSurface = isDarkMode
        ? Colors.white70
        : colorScheme.onSurface.withOpacity(0.9);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _downloadBounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _downloadBounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 72,
                  color: primary,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              isDownloading
                  ? 'Getting your book ready…'
                  : 'Preparing your book…',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (isDownloading) ...[
              Text(
                '${(_downloadProgress * 100).round()}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 14,
                  width: 220,
                  child: LinearProgressIndicator(
                    value: _downloadProgress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: primary,
                    minHeight: 14,
                  ),
                ),
              ),
            ] else
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  color: primary,
                  strokeWidth: 3,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              _userMessage!,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? Colors.white70
                    : colorScheme.onSurface.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _loadPdf,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfContent(bool isDarkMode, ColorScheme colorScheme) {
    return Stack(
      children: [
        PDFView(
          filePath: _localPdfPath!,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          defaultPage: 0,
          onRender: (pages) {
            if (mounted) {
              setState(() {
                _totalPages = pages ?? 0;
              });
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _userMessage = 'The PDF could not be displayed. Please try again.';
                _isError = true;
              });
            }
          },
          onPageChanged: (page, total) {
            if (page != null && mounted) {
              if (page != _currentPage - 1) {
                _playPageTurnAnimation(page > _currentPage - 1);
              }
              setState(() {
                _currentPage = page + 1;
              });
            }
          },
        ),
        AnimatedBuilder(
          animation: _pageAnimation,
          builder: (context, child) {
            return Positioned.fill(
              child: IgnorePointer(
                child: Transform(
                  alignment: _isForward
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_isForward
                        ? _pageAnimation.value * 0.5
                        : -_pageAnimation.value * 0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: _isForward
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        end: _isForward
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        colors: [
                          Colors.black.withOpacity(0.3 * _pageAnimation.value),
                          Colors.transparent,
                          Colors.black.withOpacity(0.3 * _pageAnimation.value),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
