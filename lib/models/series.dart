class Series {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  Series({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
