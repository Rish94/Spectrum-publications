import 'package:flutter/material.dart';
import 'package:spectrum_app/models/metadata_model.dart';
import 'package:spectrum_app/services/api_service.dart';

class MetadataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  MetadataModel? _metadata;
  bool _isLoading = false;
  String? _error;

  MetadataModel? get metadata => _metadata;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMetadata() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.getMetadata();
      _metadata = MetadataModel.fromJson(response);
      print(_metadata);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
