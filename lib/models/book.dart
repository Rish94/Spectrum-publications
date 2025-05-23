class Book {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? pdfUrl;
  final String? videoUrl;
  final String uniqueId;
  final String rate;

  Book({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.pdfUrl,
    this.videoUrl,
    required this.uniqueId,
    required this.rate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'] != null
          ? 'https://admin.spectrumpublication.in/${json['image_url'].replaceAll('public/', '')}'
          : null,
      pdfUrl: json['pdf_url'] != null
          ? 'https://admin.spectrumpublication.in/${json['pdf_url'].replaceAll('public/', '')}'
          : null,
      videoUrl: json['video_url'] != null
          ? 'https://admin.spectrumpublication.in/${json['video_url'].replaceAll('public/', '')}'
          : null,
      uniqueId: json['unique_id'],
      rate: json['rate'],
    );
  }
}
