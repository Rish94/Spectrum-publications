class Series {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String language;

  Series({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.language = 'English', // Default to English if not specified
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['imageURL']?.toString(),
      language: json['type']?.toString() ?? 'English',
    );
  }
}
