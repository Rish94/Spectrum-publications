class MetadataModel {
  final String name;
  final String tagline;
  final String email;
  final String mobile;
  final String facebookUrl;
  final String playstoreUrl;
  final String webUrl;
  final String socialUrl;

  MetadataModel({
    required this.name,
    required this.tagline,
    required this.email,
    required this.mobile,
    required this.facebookUrl,
    required this.playstoreUrl,
    required this.webUrl,
    required this.socialUrl,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      name: json['name'] ?? '',
      tagline: json['tagline'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      facebookUrl: json['facebook_url'] ?? '',
      playstoreUrl: json['playstore_url'] ?? '',
      webUrl: json['web_url'] ?? '',
      socialUrl: json['social_url'] ?? '',
    );
  }
}
