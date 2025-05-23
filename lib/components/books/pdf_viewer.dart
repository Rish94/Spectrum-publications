import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:spectrum_app/components/books/sound_manager.dart';

class AnimatedPdfViewer extends StatefulWidget {
  final File pdfFile;

  const AnimatedPdfViewer({
    super.key,
    required this.pdfFile,
  });

  @override
  State<AnimatedPdfViewer> createState() => _AnimatedPdfViewerState();
}

class _AnimatedPdfViewerState extends State<AnimatedPdfViewer> {
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;
  int _totalPages = 0;
  final SoundManager _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _soundManager.initialize();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _soundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfPdfViewer.file(
          widget.pdfFile,
          controller: _pdfViewerController,
          pageLayoutMode: PdfPageLayoutMode.single,
          scrollDirection: PdfScrollDirection.horizontal,
          enableDocumentLinkAnnotation: true,
          enableTextSelection: true,
          canShowPaginationDialog: true,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
          pageSpacing: 0,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            setState(() {
              _totalPages = details.document.pages.count;
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            setState(() {
              _currentPage = details.newPageNumber;
            });
            _soundManager.playPageTurnSound();
          },
        ),
      ],
    );
  }
}
