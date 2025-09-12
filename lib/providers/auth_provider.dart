// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import '../services/api_service.dart';

// class AuthProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();

//   User? user;
//   String? token;

//   Future<void> register({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//     required String organizationId,
//     String? blockchainIdentity,
//     required String orgType, // ✅ added orgType
//   }) async {
//     user = await _apiService.registerFarmer(
//       email: email,
//       password: password,
//       firstName: firstName,
//       lastName: lastName,
//       organizationId: organizationId,
//       blockchainIdentity: blockchainIdentity,
//       orgType: orgType, // ✅ pass it to API service
//     );
//     notifyListeners();
//   }

//   Future<User> login({required String email, required String password}) async {
//     token = await _apiService.loginFarmer(email: email, password: password);
//     user = await _apiService.getProfile();
//     notifyListeners();
//     return user!;
//   }

//   Future<void> fetchProfile() async {
//     user = await _apiService.getProfile();
//     notifyListeners();
//   }

//   void logout() async {
//     user = null;
//     token = null;
//     await _apiService.storage.delete(key: 'jwt_token');
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? user;
  String? token;

  // -----------------------------
  // Register
  // -----------------------------
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String organizationId,
    String? blockchainIdentity,
    required String orgType,
  }) async {
    try {
      // Call ApiService.registerFarmer
      user = await _apiService.registerFarmer(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        organizationId: organizationId,
        blockchainIdentity: blockchainIdentity,
        orgType: orgType,
      );

      // Optionally, fetch JWT token after registration
      token = await _apiService.loginFarmer(email: email, password: password);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------------
  // Login
  // -----------------------------
  Future<User> login({required String email, required String password}) async {
    token = await _apiService.loginFarmer(email: email, password: password);
    user = await _apiService.getProfile();
    notifyListeners();
    return user!;
  }

  // -----------------------------
  // Fetch Profile
  // -----------------------------
  Future<void> fetchProfile() async {
    user = await _apiService.getProfile();
    notifyListeners();
  }

  // -----------------------------
  // Logout
  // -----------------------------
  void logout() async {
    user = null;
    token = null;
    await _apiService.logout();
    notifyListeners();
  }
}
