import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchLogos() async {
  try {
    final url = Uri.parse('https://amandatheuri.github.io/ecopamoja-assets/logos.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
        if (kDebugMode) {
          print('Fetch failed: ${response.statusCode}');
        }
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching logos: $e');
    }
    return [];
  }
}
