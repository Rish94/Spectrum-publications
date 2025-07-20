import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:spectrum_app/components/books/sound_manager.dart';
import 'package:spectrum_app/components/custom_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:spectrum_app/config/api_config.dart';

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
    with SingleTickerProviderStateMixin {
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = true;
  String? _errorMessage;
  String? _localPdfPath;
  final SoundManager _soundManager = SoundManager();
  late AnimationController _animationController;
  late Animation<double> _pageAnimation;
  bool _isForward = true;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    contentType: ApiConfig.contentType,
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
    _downloadAndOpenPdf();
  }

  Future<void> _downloadAndOpenPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = widget.pdfUrl.split('/').last;
      final localPath = '${tempDir.path}/$fileName';

      // Download the PDF
      await _dio.download(
        widget.pdfUrl,
        localPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            setState(() {
              _errorMessage = 'Downloading: $progress%';
            });
          }
        },
      );

      setState(() {
        _localPdfPath = localPath;
        _errorMessage = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        _errorMessage = 'Error downloading PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _soundManager.dispose();
    _animationController.dispose();
    // Clean up downloaded file
    if (_localPdfPath != null) {
      try {
        File(_localPdfPath!).delete();
      } catch (e) {
        print('Error deleting temporary PDF file: $e');
      }
    }
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: CustomAppBar(
        title: _isLoading ? 'Loading...' : 'Page $_currentPage of $_totalPages',
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black54 : Colors.white70,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _downloadAndOpenPdf,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _downloadAndOpenPdf,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Stack(
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
                        setState(() {
                          _totalPages = pages!;
                          _isLoading = false;
                        });
                      },
                      onError: (error) {
                        print('PDF Error: $error');
                        setState(() {
                          _errorMessage = 'Error loading PDF: $error';
                        });
                      },
                      onPageError: (page, error) {
                        print('Page $page Error: $error');
                      },
                      onPageChanged: (page, total) {
                        if (page != _currentPage - 1) {
                          _playPageTurnAnimation(page! > _currentPage - 1);
                        }
                        setState(() {
                          _currentPage = page! + 1;
                        });
                      },
                    ),
                    if (_isLoading)
                      Container(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.7)
                            : Colors.white.withOpacity(0.7),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
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
                                      Colors.black.withOpacity(
                                          0.3 * _pageAnimation.value),
                                      Colors.transparent,
                                      Colors.black.withOpacity(
                                          0.3 * _pageAnimation.value),
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
                ),
    );
  }
}
