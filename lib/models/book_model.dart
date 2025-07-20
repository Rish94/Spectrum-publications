class BookModel {
  final int id;
  final String name;
  final double price;
  final List<BookFile> bookFiles;

  BookModel({
    required this.id,
    required this.name,
    required this.price,
    required this.bookFiles,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      bookFiles: (json['bookFiles'] as List<dynamic>?)
              ?.map((file) => BookFile.fromJson(file))
              .toList() ??
          [],
    );
  }

  String? get pdfFile {
    final pdfFile = bookFiles.firstWhere(
      (file) => file.bookType?.contentType?.toLowerCase() == 'pdf',
      orElse: () => BookFile.empty(),
    );
    return pdfFile.getFilePath();
  }

  String? get videoFile {
    final videoFile = bookFiles.firstWhere(
      (file) => file.bookType?.contentType?.toLowerCase() == 'video',
      orElse: () => BookFile.empty(),
    );
    return videoFile.getFilePath();
  }

  String? getContentFile() {
    if (bookFiles.isEmpty) return null;

    final file = bookFiles.first;
    final contentType = file.bookType?.contentType?.toLowerCase();

    if (contentType == 'pdf' || contentType == 'video') {
      return file.getFilePath();
    }

    return null;
  }
}

class BookFile {
  final int id;
  final String? link;
  final String basePath;
  final String fileType;
  final BookType? bookType;
  static const String baseUrl = 'http://164.52.218.45:5000';

  BookFile({
    required this.id,
    this.link,
    required this.basePath,
    required this.fileType,
    this.bookType,
  });

  factory BookFile.fromJson(Map<String, dynamic> json) {
    return BookFile(
      id: json['id'] ?? 0,
      link: json['link'],
      basePath: json['basePath'] ?? '',
      fileType: json['fileType'] ?? '',
      bookType:
          json['bookType'] != null ? BookType.fromJson(json['bookType']) : null,
    );
  }

  factory BookFile.empty() {
    return BookFile(
      id: 0,
      basePath: '',
      fileType: '',
    );
  }

  String? getFilePath() {
    if (basePath.isNotEmpty) {
      return '$baseUrl/$basePath';
    } else if (link != null && link!.isNotEmpty) {
      return link;
    }
    return null;
  }

  bool get isPdf => bookType?.contentType?.toLowerCase() == 'pdf';
  bool get isVideo => bookType?.contentType?.toLowerCase() == 'video';
}

class BookType {
  final int id;
  final String typeName;
  final String contentType;

  BookType({
    required this.id,
    required this.typeName,
    required this.contentType,
  });

  factory BookType.fromJson(Map<String, dynamic> json) {
    return BookType(
      id: json['id'] ?? 0,
      typeName: json['typeName'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }
}
