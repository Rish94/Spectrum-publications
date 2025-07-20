import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/providers/theme_provider.dart';
import 'package:spectrum_app/config/theme_helper.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // List of engaging colors for menu items
    final List<Color> menuColors = [
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF9800), // Orange
      const Color(0xFFE91E63), // Pink
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFF795548), // Brown
      const Color(0xFF009688), // Teal
      const Color(0xFF3F51B5), // Indigo
    ];

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        const Color(0xFF2C2C2C),
                        const Color(0xFF1A1A1A),
                      ]
                    : [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.8),
                      ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/books.jpg',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Spectrum App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  'Your Learning Journey',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.home_rounded,
            title: 'Home',
            route: '/',
            color: menuColors[0],
            isSelected: currentRoute == '/',
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.book_rounded,
            title: 'E-Books',
            route: '/series',
            color: menuColors[1],
            isSelected: currentRoute == '/series',
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.info_rounded,
            title: 'About',
            route: '/about',
            color: menuColors[2],
            isSelected: currentRoute == '/about',
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.contact_support_rounded,
            title: 'Contact',
            route: '/contact',
            color: menuColors[3],
            isSelected: currentRoute == '/contact',
            isDarkMode: isDarkMode,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? colorScheme.primary.withOpacity(0.2)
                    : colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: isDarkMode
                    ? colorScheme.primary.withOpacity(0.9)
                    : colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.8)
                    : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required Color color,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isDarkMode
                    ? [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                      ]
                    : [
                        color.withOpacity(0.1),
                        color.withOpacity(0.05),
                      ],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(
                color: isDarkMode
                    ? color.withOpacity(0.3)
                    : color.withOpacity(0.2),
                width: 1,
              )
            : null,
      ),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          context.push(route);
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? color.withOpacity(0.2) : color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDarkMode ? color.withOpacity(0.9) : color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDarkMode
                ? Colors.white.withOpacity(isSelected ? 1 : 0.8)
                : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? color.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode ? color.withOpacity(0.9) : color,
                  size: 16,
                ),
              )
            : null,
      ),
    );
  }
}
