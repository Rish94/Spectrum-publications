import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/components/app_drawer.dart';
import 'package:spectrum_app/providers/theme_provider.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.background,
      endDrawer: const AppDrawer(currentRoute: '/contact'),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: const Text('Contact Us'),
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
              'Get in Touch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We\'d love to hear from you! Please use the form below to send us a message.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildContactForm(),
            const SizedBox(height: 32),
            const Text(
              'Other Ways to Reach Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactInfo(
              icon: Icons.email,
              title: 'Email',
              content: 'support@spectrumpublications.com',
            ),
            _buildContactInfo(
              icon: Icons.phone,
              title: 'Phone',
              content: '+1 (555) 123-4567',
            ),
            _buildContactInfo(
              icon: Icons.location_on,
              title: 'Address',
              content: '123 Education Street\nLearning City, ED 12345',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement form submission
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String content,
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
                  content,
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
