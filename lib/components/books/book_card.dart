import 'package:flutter/material.dart';
import 'package:spectrum_app/config/theme_helper.dart';
import 'package:spectrum_app/models/book_model.dart';
import 'dart:math';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  Color _getRandomColor(String bookName) {
    final seed = bookName.codeUnits.reduce((a, b) => a + b);
    final random = Random(seed);
    return _bookColors[random.nextInt(_bookColors.length)];
  }

  static const List<Color> _bookColors = [
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFF9C27B0), // Purple
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
    Color(0xFF00BCD4), // Cyan
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF795548), // Brown
    Color(0xFF009688), // Teal
    Color(0xFF3F51B5), // Indigo
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF607D8B), // Blue Grey
    Color(0xFFEC407A), // Pink Accent
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final bookColor = _getRandomColor(book.name);
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : bookColor;
    final gradientColors = isDarkMode
        ? [
            bookColor.withOpacity(0.15),
            bookColor.withOpacity(0.05),
          ]
        : [
            bookColor.withOpacity(0.1),
            bookColor.withOpacity(0.05),
          ];

    return Card(
      elevation: isDarkMode ? 2 : 4,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDarkMode
                              ? [
                                  bookColor.withOpacity(0.4),
                                  bookColor.withOpacity(0.2),
                                ]
                              : [
                                  bookColor.withOpacity(0.3),
                                  bookColor.withOpacity(0.1),
                                ],
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/books.jpg'),
                          fit: BoxFit.cover,
                          opacity: 0.7,
                        ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? bookColor.withOpacity(0.2)
                                  : bookColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDarkMode
                                    ? bookColor.withOpacity(0.4)
                                    : bookColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '₹${book.price}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[850]
                      : bookColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode
                          ? Colors.grey[800]!
                          : bookColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.book,
                          color: textColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'View Content',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
