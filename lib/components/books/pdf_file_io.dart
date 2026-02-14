import 'dart:io';

/// Deletes a local PDF file if path is not null. Used for cleanup on mobile.
void deletePdfFile(String? path) {
  if (path != null && path.isNotEmpty) {
    try {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }
}
