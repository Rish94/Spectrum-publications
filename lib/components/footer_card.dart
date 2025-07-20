import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spectrum_app/providers/metadata_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterCard extends StatelessWidget {
  const FooterCard({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final metadataProvider = Provider.of<MetadataProvider>(context);
    final metadata = metadataProvider.metadata;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (metadataProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (metadataProvider.error != null) {
      return Center(
        child: Text(
          'Error loading metadata: ${metadataProvider.error}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    if (metadata == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF4158D0).withOpacity(0.2),
                  const Color(0xFFC850C0).withOpacity(0.1),
                ]
              : [
                  const Color(0xFFBBDEFB), // Light Blue 200
                  const Color(0xFF90CAF9), // Light Blue 300
                ],
        ),
        borderRadius: BorderRadius.circular(20),
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
          Text(
            metadata.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metadata.tagline,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (metadata.facebookUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.facebook),
                  onPressed: () => _launchUrl(metadata.facebookUrl),
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              if (metadata.socialUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => _launchUrl(metadata.socialUrl),
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              if (metadata.webUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () => _launchUrl(metadata.webUrl),
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              if (metadata.playstoreUrl.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.android),
                  onPressed: () => _launchUrl(metadata.playstoreUrl),
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (metadata.email.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.email),
                  label: Text(metadata.email),
                  onPressed: () => _launchUrl('mailto:${metadata.email}'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              if (metadata.mobile.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.phone),
                  label: Text(metadata.mobile),
                  onPressed: () => _launchUrl('tel:${metadata.mobile}'),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
