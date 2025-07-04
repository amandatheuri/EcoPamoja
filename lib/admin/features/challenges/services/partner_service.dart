import 'dart:convert';
import 'package:ecopamoja/admin/features/challenges/models/logourl.dart';
import 'package:http/http.dart' as http;

class PartnerLogoService {
  static const String logosUrl = 'https://amandatheuri.github.io/ecopamoja-assets/logos.json';

  static Future<List<LogoLink>> fetchLogos() async {
    final response = await http.get(Uri.parse(logosUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => LogoLink.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load logos');
    }
  }
}
