import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://admin.spectrumpublication.in/mobile';

  // Get all series
  Future<List<dynamic>> getAllSeries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/series'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load series');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get classes of a specific series
  Future<List<dynamic>> getClassesOfSeries(String seriesId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/series/$seriesId/classes'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get books of a specific series and class
  Future<List<dynamic>> getBooksOfClass(String seriesId, String classId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/series/$seriesId/class/$classId/books'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
