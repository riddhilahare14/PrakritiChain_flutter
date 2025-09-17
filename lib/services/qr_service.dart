// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../config.dart';

// class QRCodeService {
//   static const String baseUrl = '${AppConfig.baseUrl}/api/qr-codes';

//   /// Generate QR code for a collection/batch
//   static Future<Map<String, dynamic>?> generateQRCode({
//     required String token,
//     required String entityType,
//     required String entityId,
//     Map<String, dynamic>? customData,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'entityType': entityType,
//           'entityId': entityId,
//           'customData': customData,
//         }),
//       );

//       if (response.statusCode == 201) {
//         return jsonDecode(response.body);
//       } else {
//         print('QR Generation failed: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('QR Generation error: $e');
//       return null;
//     }
//   }

//   /// Get QR code image by entity ID
//   static Future<Uint8List?> getQRCodeImageByEntityId({
//     required String entityId,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/image/$entityId'),
//         headers: {
//           'Content-Type': 'image/png',
//         },
//       );

//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         print('QR Image fetch failed: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('QR Image fetch error: $e');
//       return null;
//     }
//   }

//   /// Scan QR code by hash
//   static Future<Map<String, dynamic>?> scanQRCode({
//     required String qrHash,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/scan/$qrHash'),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         print('QR Scan failed: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('QR Scan error: $e');
//       return null;
//     }
//   }

//   /// Save QR code image to device
//   static Future<String?> saveQRCodeImage({
//     required GlobalKey qrKey,
//     required String fileName,
//   }) async {
//     try {
//       RenderRepaintBoundary boundary = 
//           qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       ui.Image image = await boundary.toImage();
//       ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
//       if (byteData != null) {
//         final directory = await getApplicationDocumentsDirectory();
//         final file = File('${directory.path}/$fileName.png');
//         await file.writeAsBytes(byteData.buffer.asUint8List());
//         return file.path;
//       }
//       return null;
//     } catch (e) {
//       print('Save QR image error: $e');
//       return null;
//     }
//   }
// }