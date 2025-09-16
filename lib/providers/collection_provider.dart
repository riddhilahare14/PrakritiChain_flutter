import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import '../config.dart';

class CollectionProvider with ChangeNotifier {
  static const String baseUrl = '${AppConfig.baseUrl}/api/collections';

  final AuthProvider authProvider;
  List<dynamic> _collections = [];

  List<dynamic> get collections => _collections;

  CollectionProvider(this.authProvider);

  /// Fetch collections for the logged-in user
  Future<void> fetchCollections() async {
    final token = authProvider.token;
    final url = Uri.parse('$baseUrl/by-farmer');

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _collections = data['data'] ?? [];
        notifyListeners();
      } else if (response.statusCode == 401) {
        // Token is invalid or expired
        debugPrint("Invalid token detected. Logging out...");
        _handleInvalidToken();
      } else {
        debugPrint(
            "Failed to fetch collections. Status: ${response.statusCode}, Body: ${response.body}");
        _collections = [];
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching collections: $e");
      _collections = [];
      notifyListeners();
    }
  }

  /// Refresh collections safely
  Future<void> refreshCollections() async {
    await fetchCollections();
  }

  /// Clear data and log out if token is invalid
  void _handleInvalidToken() {
    _collections = [];
    notifyListeners();
    authProvider.logout(); // clears user and token
  }
}
