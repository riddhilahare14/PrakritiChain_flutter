import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  //   static Future<List<dynamic>> fetchSpeciesRules() async {
  //   final resp = await http.get(Uri.parse('$baseUrl/species_rules'));

  //   if (resp.statusCode == 200) return jsonDecode(resp.body);
  //   throw Exception('Failed to load species rules');
  // }

  // dummy
  static Future<List<dynamic>> fetchSpeciesRules() async {
    final resp = await http.get(Uri.parse('$baseUrl/posts'));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      // map to your expected fields
      return list.map((item) => {
        'speciesCode': item['id'].toString(),
        'commonName': item['title'] ?? 'Unknown',
        'geoFence': null,
      }).toList();
    }
    throw Exception('Failed to load species rules');
  }

  static Future<Map<String, dynamic>> uploadPhoto(File file) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    throw Exception('Upload failed');
  }

  static Future<bool> submitCollection(Map<String, dynamic> payload) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/collection_events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return resp.statusCode == 201 || resp.statusCode == 200;
  }
}
