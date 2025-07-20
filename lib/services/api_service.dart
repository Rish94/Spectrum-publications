import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spectrum_app/config/api_config.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    contentType: ApiConfig.contentType,
  ));

  // Get classes of a specific series
  Future<List<dynamic>> getClassesOfSeries(String seriesId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.getClassesOfSeries.replaceAll('{seriesId}', seriesId)}'),
        headers: {'Content-Type': ApiConfig.contentType},
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
        Uri.parse(
            '${ApiConfig.baseUrl}${ApiConfig.getBooksOfClass.replaceAll('{seriesId}', seriesId).replaceAll('{classId}', classId)}'),
        headers: {'Content-Type': ApiConfig.contentType},
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

  // Get series by medium (Hindi/English)
  Future<List<dynamic>> getSeriesByMedium(String medium) async {
    try {
      print("$medium");
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getSeries}'),
        headers: {'Content-Type': ApiConfig.contentType},
        body: json.encode({'medium': '$medium Medium'}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception('Failed to load series');
        }
      } else {
        throw Exception('Failed to load series: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get all content types
  Future<List<dynamic>> getContentTypes() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getTypes}'),
        headers: {'Content-Type': ApiConfig.contentType},
        body: json.encode({}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception('Failed to load content types');
        }
      } else {
        throw Exception('Failed to load content types: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get classes by series ID
  Future<List<dynamic>> getClassesBySeries(String seriesId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getClasses}'),
        headers: {'Content-Type': ApiConfig.contentType},
        body: json.encode({'seriesId': int.parse(seriesId)}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception('Failed to load classes');
        }
      } else {
        throw Exception('Failed to load classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get subjects by series ID
  Future<List<dynamic>> getSubjectsBySeries(String seriesId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getSubjects}'),
        headers: {'Content-Type': ApiConfig.contentType},
        body: json.encode({'seriesId': int.parse(seriesId)}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception('Failed to load subjects');
        }
      } else {
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get books by class ID and type ID
  Future<List<dynamic>> getBooksByClassAndType(
      String classId, String typeId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getBooks}'),
        headers: {'Content-Type': ApiConfig.contentType},
        body: json.encode({
          'classId': int.parse(classId),
          'typeId': int.parse(typeId),
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception('Failed to load books');
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getMetadata() async {
    try {
      final response = await _dio.post(
        ApiConfig.getMetadata,
        data: {},
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to load metadata');
      }
    } catch (e) {
      throw Exception('Failed to load metadata: $e');
    }
  }
}
