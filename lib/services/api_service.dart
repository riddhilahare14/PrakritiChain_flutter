import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config.dart';

class ApiService {
  // static const String baseUrl = "http://10.0.2.2:3000/api/auth"; // Emulator loopback
  static const String baseUrl = '${AppConfig.baseUrl}/api/auth';
  final storage = const FlutterSecureStorage();

  // -----------------------------
  // Register Farmer / Any orgType
  // -----------------------------
  Future<User> registerFarmer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String organizationId,
    String? blockchainIdentity,
    required String orgType,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "organizationId": organizationId,
        "orgType": orgType,
        "blockchainIdentity": blockchainIdentity ?? "none",
      }),
    );

    final data = jsonDecode(response.body);
    print("Register response: $data"); // ✅ Debug

    if (response.statusCode == 201) {
      if (data['user'] == null) {
        throw Exception("Registration failed: User data missing in response");
      }
      return User.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  // -----------------------------
  // Login Farmer
  // -----------------------------
  Future<String> loginFarmer({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    print("Login response: $data"); // Debug

    if (response.statusCode == 200) {
      final token = data['data']['token']; // ✅ Correct path
      if (token == null || token.isEmpty) {
        throw Exception('Login failed: Token missing');
      }

      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }



  // -----------------------------
  // Get Current User Profile
  // -----------------------------
  Future<User> getProfile() async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please login first.");
    }

    final url = Uri.parse('$baseUrl/me');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    final data = jsonDecode(response.body);
    print("Profile response: $data"); // ✅ Debug

    if (response.statusCode == 200) {
      if (data['user'] == null) {
        throw Exception("Failed to fetch profile: User data missing");
      }
      return User.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch profile');
    }
  }

  // -----------------------------
  // Logout
  // -----------------------------
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}
