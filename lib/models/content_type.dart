import 'package:flutter/material.dart';

class ContentType {
  final int id;
  final String typeName;
  final String description;
  final String contentType;

  ContentType({
    required this.id,
    required this.typeName,
    required this.description,
    required this.contentType,
  });

  factory ContentType.fromJson(Map<String, dynamic> json) {
    return ContentType(
      id: json['id'] ?? 0,
      typeName: json['typeName'] ?? '',
      description: json['description'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }

  IconData getIcon() {
    switch (typeName.toLowerCase()) {
      case 'content manual':
        return Icons.book;
      case 'teachers manual':
        return Icons.school;
      case 'video lectures':
        return Icons.video_library;
      case 'exam papers':
        return Icons.assignment;
      case 'order form':
        return Icons.shopping_cart;
      default:
        return Icons.article;
    }
  }

  List<Color> getGradient() {
    switch (typeName.toLowerCase()) {
      case 'content manual':
        return [const Color(0xFF4158D0), const Color(0xFFC850C0)];
      case 'teachers manual':
        return [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)];
      case 'video lectures':
        return [const Color(0xFF0093E9), const Color(0xFF80D0C7)];
      case 'exam papers':
        return [const Color(0xFF00DBDE), const Color(0xFFFC00FF)];
      case 'order form':
        return [const Color(0xFFFF9A8B), const Color(0xFFFF6A88)];
      default:
        return [const Color(0xFF4158D0), const Color(0xFFC850C0)];
    }
  }
}
