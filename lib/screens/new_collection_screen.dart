// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:path/path.dart' as p;
// import 'package:mime/mime.dart';

// import '../providers/auth_provider.dart';
// import '../widgets/species_dropdown.dart';

// class NewCollectionScreen extends StatefulWidget {
//   const NewCollectionScreen({super.key});

//   @override
//   State<NewCollectionScreen> createState() => _NewCollectionScreenState();
// }

// class _NewCollectionScreenState extends State<NewCollectionScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();

//   String? _selectedSpeciesId;
//   bool _isLoading = false;
//   File? _photoFile;

//   /// Pick photo using camera
//   Future<void> _pickPhoto() async {
//     final picker = ImagePicker();
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

//     if (pickedFile != null) {
//       setState(() {
//         _photoFile = File(pickedFile.path);
//       });
//     }
//   }

//   /// Get current device location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enable location services')),
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }

//     if (permission == LocationPermission.deniedForever) return;

//     final position =
//         await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _latitudeController.text = position.latitude.toString();
//       _longitudeController.text = position.longitude.toString();
//     });
//   }

//   /// Upload photo to Cloudinary
//   Future<String?> uploadPhotoToCloudinary(File? file) async {
//     if (file == null) return null;

//     const cloudName = "dxlojiwxm"; // your cloud name
//     const uploadPreset = "flutter_upload"; // your unsigned preset

//     final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

//     final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
//     final request = http.MultipartRequest('POST', uri);

//     request.fields['upload_preset'] = uploadPreset;

//     request.files.add(
//       http.MultipartFile(
//         'file',
//         file.readAsBytes().asStream(),
//         file.lengthSync(),
//         filename: p.basename(file.path),
//         contentType: MediaType.parse(mimeType),
//       ),
//     );

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final respStr = await response.stream.bytesToString();
//       final json = jsonDecode(respStr);
//       return json['secure_url']; // uploaded image URL
//     } else {
//       print("Cloudinary upload failed: ${response.statusCode}");
//       return null;
//     }
//   }

//   /// Submit collection
//   Future<void> _submitCollection() async {
//     if (!_formKey.currentState!.validate() || _selectedSpeciesId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please fill all required fields")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final token = authProvider.token;

//     // Upload photo if present
//     final uploadedPhotoUrl = await uploadPhotoToCloudinary(_photoFile);

//     final body = jsonEncode({
//       "herbSpeciesId": _selectedSpeciesId, // send UUID as string
//       "quantityKg": double.tryParse(_quantityController.text) ?? 0,
//       "initialQualityMetrics": jsonEncode({
//         "moisture": 12.5,
//         "purity": 95,
//         "color": "green",
//         "aroma": "strong",
//       }),
//       "photoUrl": uploadedPhotoUrl ?? "",
//       "location": jsonEncode({
//         "latitude": double.tryParse(_latitudeController.text) ?? 0,
//         "longitude": double.tryParse(_longitudeController.text) ?? 0,
//       }),
//     });


//     try {
//       final response = await http.post(
//         Uri.parse("http://10.0.2.2:3000/api/collections"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: body,
//       );

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ Collection created successfully")),
//         );
//         Navigator.pop(context);
//       } else {
//         print("Server response: ${response.body}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ Failed: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("New Collection")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               SpeciesDropdown(
//                 onSelected: (speciesId) {
//                   setState(() {
//                     _selectedSpeciesId = speciesId;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: const InputDecoration(labelText: "Quantity (Kg)"),
//                 keyboardType: TextInputType.number,
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Enter quantity" : null,
//               ),
//               const Divider(),
//               const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _pickPhoto,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Take Photo"),
//                   ),
//                   const SizedBox(width: 10),
//                   _photoFile != null
//                       ? Image.file(_photoFile!,
//                           width: 80, height: 80, fit: BoxFit.cover)
//                       : const Text("No photo selected"),
//                 ],
//               ),
//               const Divider(),
//               const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _getCurrentLocation,
//                     icon: const Icon(Icons.my_location),
//                     label: const Text("Use Current Location"),
//                   ),
//                   const SizedBox(width: 10),
//                   if (_latitudeController.text.isNotEmpty &&
//                       _longitudeController.text.isNotEmpty)
//                     Text(
//                         "Lat: ${_latitudeController.text}, Lng: ${_longitudeController.text}"),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _latitudeController,
//                 decoration: const InputDecoration(labelText: "Latitude"),
//                 keyboardType: TextInputType.number,
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Enter latitude" : null,
//               ),
//               TextFormField(
//                 controller: _longitudeController,
//                 decoration: const InputDecoration(labelText: "Longitude"),
//                 keyboardType: TextInputType.number,
//                 validator: (val) =>
//                     val == null || val.isEmpty ? "Enter longitude" : null,
//               ),
//               const SizedBox(height: 24),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _submitCollection,
//                       child: const Text("Create Collection"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// ------------------------------------------ UI BY GEMINI ------------------------------------------


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';

import '../providers/auth_provider.dart';
import '../widgets/species_dropdown.dart';
import '../utils/colors.dart'; // Import the new colors file

class NewCollectionScreen extends StatefulWidget {
  const NewCollectionScreen({super.key});

  @override
  State<NewCollectionScreen> createState() => _NewCollectionScreenState();
}

class _NewCollectionScreenState extends State<NewCollectionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String? _selectedSpeciesId;
  bool _isLoading = false;
  File? _photoFile;

  /// Pick photo using camera
  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _photoFile = File(pickedFile.path);
      });
    }
  }

  /// Get current device location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    });
  }

  /// Upload photo to Cloudinary
  Future<String?> uploadPhotoToCloudinary(File? file) async {
    if (file == null) return null;

    const cloudName = "dxlojiwxm";
    const uploadPreset = "flutter_upload";

    final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: p.basename(file.path),
        contentType: MediaType.parse(mimeType),
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        return json['secure_url'];
      } else {
        print("Cloudinary upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Cloudinary upload failed with error: $e");
      return null;
    }
  }

  /// Submit collection
  Future<void> _submitCollection() async {
    if (!_formKey.currentState!.validate() || _selectedSpeciesId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all required fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final uploadedPhotoUrl = await uploadPhotoToCloudinary(_photoFile);
    if (_photoFile != null && uploadedPhotoUrl == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to upload photo.")),
      );
      return;
    }

    final body = jsonEncode({
      "herbSpeciesId": _selectedSpeciesId,
      "quantityKg": double.tryParse(_quantityController.text) ?? 0,
      "initialQualityMetrics": jsonEncode({
        "moisture": 12.5,
        "purity": 95,
        "color": "green",
        "aroma": "strong",
      }),
      "photoUrl": uploadedPhotoUrl ?? "",
      "location": jsonEncode({
        "latitude": double.tryParse(_latitudeController.text) ?? 0,
        "longitude": double.tryParse(_longitudeController.text) ?? 0,
      }),
    });

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/collections"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Collection created successfully")),
        );
        Navigator.pop(context, true);
      } else {
        print("Server response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          "New Collection",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Species Dropdown
              _buildCard(
                child: SpeciesDropdown(
                  onSelected: (speciesId) {
                    setState(() {
                      _selectedSpeciesId = speciesId;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Quantity Field
              _buildCard(
                child: TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: "Quantity (Kg)",
                    border: InputBorder.none,
                    filled: false,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? "Enter quantity" : null,
                ),
              ),

              const SizedBox(height: 16),

              // Photo Section
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textColor)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: _pickPhoto,
                            icon: const Icon(Icons.photo_camera),
                            label: const Text("Take Photo"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _photoFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(_photoFile!, width: 60, height: 60, fit: BoxFit.cover),
                              )
                            : const Text("No photo selected", style: TextStyle(color: AppColors.subtitleColor)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Location Section
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(width: 12),
                        const Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textColor)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text("Use Current Location"),
                    ),
                    if (_latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Lat: ${_latitudeController.text}, Lng: ${_longitudeController.text}", style: const TextStyle(color: AppColors.subtitleColor)),
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(labelText: "Latitude", border: InputBorder.none, filled: false),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? "Enter latitude" : null,
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(labelText: "Longitude", border: InputBorder.none, filled: false),
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.isEmpty ? "Enter longitude" : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                  : ElevatedButton(
                      onPressed: _submitCollection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Create Collection",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}