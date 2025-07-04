// lib/utils/validators.dart
class AppValidators {
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final urlPattern = r'^(https?://)?([\w-]+\.)+[\w-]+(:\d+)?(/[\w-./?%&=]*)?$';
    return RegExp(urlPattern, caseSensitive: false).hasMatch(value.trim()) 
        ? null 
        : 'Enter valid URL';
  }
  
}