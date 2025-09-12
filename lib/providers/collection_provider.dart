// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'auth_provider.dart';

// class CollectionProvider with ChangeNotifier {
//   final AuthProvider authProvider;
//   List<dynamic> _collections = [];

//   List<dynamic> get collections => _collections;

//   CollectionProvider(this.authProvider);

//   /// Fetch collections for the logged-in user
//   Future<void> fetchCollections() async {
//     final token = authProvider.token;
//     final userId = authProvider.user!.userId;
//     final url = Uri.parse("http://10.0.2.2:3000/api/collections/by-farmer");

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // Expecting data['data'] to be a list of CollectionEvent
//         _collections = data['data'] ?? [];
//         notifyListeners();
//       } else {
//         print('Failed to fetch collections: ${response.body}');
//         _collections = [];
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error fetching collections: $e');
//       _collections = [];
//       notifyListeners();
//     }
//   }

//   /// Optional: refresh after adding a new collection
//   Future<void> refreshCollections() async {
//     await fetchCollections();
//     notifyListeners();
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

class CollectionProvider with ChangeNotifier {
  final AuthProvider authProvider;
  List<dynamic> _collections = [];

  List<dynamic> get collections => _collections;

  CollectionProvider(this.authProvider);

  /// Fetch collections for the logged-in user
  Future<void> fetchCollections() async {
    final token = authProvider.token;
    final url = Uri.parse("http://10.0.2.2:3000/api/collections/by-farmer");

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
