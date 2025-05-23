import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/providers/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/about'),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text('About Us'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.verified_user),
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
              'About Spectrum Publications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Spectrum Publications is dedicated to providing high-quality educational resources for students. Our mission is to make learning accessible, engaging, and effective through innovative digital content.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To be the leading provider of educational resources that empower students to achieve their full potential.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Values',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildValueItem(
              icon: Icons.school,
              title: 'Excellence in Education',
              description:
                  'We are committed to providing the highest quality educational content.',
            ),
            _buildValueItem(
              icon: Icons.book,
              title: 'Innovation',
              description:
                  'We continuously innovate to create engaging and effective learning experiences.',
            ),
            _buildValueItem(
              icon: Icons.accessibility,
              title: 'Accessibility',
              description:
                  'We believe in making education accessible to all students.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
