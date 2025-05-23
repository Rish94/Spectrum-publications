class Class {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  Class({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
