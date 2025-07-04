class LogoLink {
  final String name;
  final String key;
  LogoLink({
    required this.name, 
    required this.key
  });
  factory LogoLink.fromJson(Map<String, dynamic> json) {
    return LogoLink(
      name: json['name'],
      key: json['key'],
    );
  }
}