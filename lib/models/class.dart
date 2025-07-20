class Class {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? subjectId;

  Class({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.subjectId,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      subjectId: json['subjectId'],
    );
  }
}
