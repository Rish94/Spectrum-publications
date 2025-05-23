import 'package:flutter/material.dart';
import 'package:spectrum_app/models/book.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/components/loaders/book_loader.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isPdfLoading;
  final VoidCallback? onPdfTap;
  final VoidCallback? onVideoTap;

  const BookCard({
    super.key,
    required this.book,
    required this.isPdfLoading,
    this.onPdfTap,
    this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: Hero(
            tag: 'book-${book.id}',
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: book.pdfUrl != null && !isPdfLoading ? onPdfTap : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: ThemeHelper.getCardDecoration(
                    gradientColors: ThemeHelper.secondaryGradient,
                    isVertical: true,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: book.imageUrl != null
                                      ? Image.network(
                                          book.imageUrl!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              decoration: ThemeHelper
                                                  .getPlaceholderDecoration(),
                                              child: Center(
                                                child: BookLoader(
                                                  size: 30,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              decoration: ThemeHelper
                                                  .getPlaceholderDecoration(),
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.5),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          decoration: ThemeHelper
                                              .getPlaceholderDecoration(),
                                          child: Icon(
                                            Icons.book,
                                            size: 50,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                ),
                                // if (book.pdfUrl != null)
                                //   Positioned(
                                //     top: 8,
                                //     right: 8,
                                //     child: Container(
                                //       padding: const EdgeInsets.all(4),
                                //       decoration: BoxDecoration(
                                //         gradient: ThemeHelper.getGradient(
                                //             ThemeHelper.accentGradient),
                                //         borderRadius: BorderRadius.circular(4),
                                //       ),
                                //       child: Icon(
                                //         Icons.picture_as_pdf,
                                //         color: Colors.white,
                                //         size: 20,
                                //       ),
                                //     ),
                                //   ),
                                if (isPdfLoading)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: ThemeHelper.getGradient(
                                        [
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.5)
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: ThemeHelper.getGradient(
                                  [
                                    colorScheme.surface,
                                    colorScheme.surface.withOpacity(0.9)
                                  ],
                                  isVertical: true,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    book.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: ThemeHelper.getGradient(
                                          ThemeHelper.primaryGradient),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '₹${book.rate}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (book.videoUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: ThemeHelper.getCardDecoration(
                gradientColors: ThemeHelper.accentGradient,
              ),
              child: ElevatedButton.icon(
                onPressed: onVideoTap,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Video'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
