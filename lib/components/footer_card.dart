import 'package:flutter/material.dart';
import 'package:spectrum_app/components/text_style.dart';
import 'package:spectrum_app/config/theme_helper.dart';

class FooterCard extends StatelessWidget {
  const FooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: isDarkMode ? colorScheme.surface : colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Spectrum Publications",
            style: Text_Style.large(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ).copyWith(
              color: isDarkMode ? colorScheme.onSurface : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Empowering Education Through Innovation",
            style: Text_Style.small().copyWith(
              color: isDarkMode
                  ? colorScheme.onSurface.withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                Icons.facebook,
                () {},
                const Color(0xFF1877F2),
                isDarkMode,
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                Icons.telegram,
                () {},
                const Color(0xFF0088CC),
                isDarkMode,
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                Icons.message,
                () {},
                const Color(0xFF25D366),
                isDarkMode,
              ),
              const SizedBox(width: 16),
              _buildSocialIcon(
                Icons.youtube_searched_for,
                () {},
                const Color(0xFFFF0000),
                isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Connect With Us",
            style: Text_Style.medium().copyWith(
              color: isDarkMode
                  ? colorScheme.onSurface.withOpacity(0.9)
                  : Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            child: Text(
              "Copyright © Spectrum Publications ${DateTime.now().year}. All Rights Reserved",
              style: Text_Style.small().copyWith(
                color: isDarkMode
                    ? colorScheme.onSurface.withOpacity(0.6)
                    : Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(
      IconData icon, VoidCallback onTap, Color brandColor, bool isDarkMode) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? brandColor.withOpacity(0.1)
              : Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode
                ? brandColor.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDarkMode ? brandColor : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
