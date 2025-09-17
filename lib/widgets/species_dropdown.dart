// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import '../providers/auth_provider.dart';
// import '../utils/colors.dart'; // Import the new colors file
// import '../config.dart';

// class SpeciesDropdown extends StatefulWidget {
//   final void Function(String?) onSelected;

//   const SpeciesDropdown({super.key, required this.onSelected});

//   @override
//   State<SpeciesDropdown> createState() => _SpeciesDropdownState();
// }

// class _SpeciesDropdownState extends State<SpeciesDropdown> {
//   static const String baseUrl = '${AppConfig.baseUrl}/api/species';

//   List<Map<String, dynamic>> _speciesList = [];
//   String? _selectedSpeciesId;
//   bool _loading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSpecies();
//   }

//   Future<void> _fetchSpecies() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final token = authProvider.token;

//     try {
//       final response = await http.get(
//         Uri.parse("$baseUrl?page=1&limit=50"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         final List<dynamic> data = jsonData['data']['species'];

//         setState(() {
//           _speciesList = data.map((s) {
//             return {
//               "id": s['speciesId'] ?? s['id'],
//               "commonName": s['commonName'] ?? s['common_name'] ?? '',
//               "scientificName": s['scientificName'] ?? s['scientific_name'] ?? '',
//             };
//           }).toList();
//           _loading = false;
//           _selectedSpeciesId = null;
//         });
//       } else {
//         setState(() {
//           _error = "Error: ${response.body}";
//           _loading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = "⚠️ Failed to load species: $e";
//         _loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
//     }
//     if (_error != null) {
//       return Text(_error!, style: const TextStyle(color: Colors.red));
//     }

//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         labelText: "Select a Species",
//         labelStyle: TextStyle(color: AppColors.subtitleColor),
//         border: InputBorder.none,
//         filled: false,
//       ),
//       value: _selectedSpeciesId,
//       hint: const Text("Select a species", style: TextStyle(color: AppColors.subtitleColor)),
//       items: _speciesList.map((s) {
//         return DropdownMenuItem<String>(
//           value: s["id"],
//           child: Text("${s["commonName"]} (${s["scientificName"]})", style: const TextStyle(color: AppColors.textColor)),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedSpeciesId = value;
//         });
//         widget.onSelected(value);
//       },
//       validator: (val) => val == null ? "Please select a species" : null,
//       dropdownColor: AppColors.cardBackground,
//       iconEnabledColor: AppColors.primaryGreen,
//     );
//   }
// }


// ----------------- CLAUDE ----------------------




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// import '../providers/auth_provider.dart';
// import '../utils/colors.dart';
// import '../config.dart';

// class SpeciesDropdown extends StatefulWidget {
//   final Function(String speciesId, String speciesName) onSelected;

//   const SpeciesDropdown({
//     super.key,
//     required this.onSelected,
//   });

//   @override
//   State<SpeciesDropdown> createState() => _SpeciesDropdownState();
// }

// class _SpeciesDropdownState extends State<SpeciesDropdown> {
//   static const String baseUrl = '${AppConfig.baseUrl}/api/species';
//   List<Map<String, dynamic>> _species = [];
//   bool _isLoading = false;
//   String? _selectedSpeciesId;
//   String? _selectedSpeciesName;

//   @override
//   void initState() {
//     super.initState();
//     _loadSpecies();
//   }

//   Future<void> _loadSpecies() async {
//     setState(() => _isLoading = true);

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final token = authProvider.token;

//       final response = await http.get(
//         // Uri.parse('${AppConfig.baseUrl}/api/herb-species'), // Adjust endpoint as needed
//         Uri.parse("$baseUrl?page=1&limit=50"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         setState(() {
//           _species = List<Map<String, dynamic>>.from(responseData['data'] ?? []);
//         });
//       } else {
//         print('Failed to load species: ${response.body}');
//       }
//     } catch (e) {
//       print('Error loading species: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryGreen.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.eco, color: AppColors.primaryGreen),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               "Herb Species",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: AppColors.textColor,
//               ),
//             ),
//             const Text(
//               " *",
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_isLoading)
//           const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
//         else
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             decoration: BoxDecoration(
//               border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedSpeciesId,
//                 hint: const Text(
//                   "Select herb species",
//                   style: TextStyle(color: AppColors.subtitleColor),
//                 ),
//                 isExpanded: true,
//                 icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryGreen),
//                 items: _species.map<DropdownMenuItem<String>>((species) {
//                   return DropdownMenuItem<String>(
//                     value: species['speciesId'] ?? species['id'], // Handle different field names
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           species['commonName'] ?? species['name'] ?? 'Unknown',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.textColor,
//                           ),
//                         ),
//                         if (species['scientificName'] != null)
//                           Text(
//                             species['scientificName'],
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontStyle: FontStyle.italic,
//                               color: AppColors.subtitleColor,
//                             ),
//                           ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     final selectedSpecies = _species.firstWhere(
//                       (species) => (species['speciesId'] ?? species['id']) == newValue,
//                     );
                    
//                     setState(() {
//                       _selectedSpeciesId = newValue;
//                       _selectedSpeciesName = selectedSpecies['commonName'] ?? 
//                                           selectedSpecies['name'] ?? 
//                                           'Unknown Herb';
//                     });
                    
//                     // Call the callback with both ID and name
//                     widget.onSelected(newValue, _selectedSpeciesName!);
//                   }
//                 },
//               ),
//             ),
//           ),
//         if (_species.isEmpty && !_isLoading)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               children: [
//                 const Icon(Icons.info_outline, size: 16, color: AppColors.subtitleColor),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "No species available",
//                   style: TextStyle(color: AppColors.subtitleColor, fontSize: 12),
//                 ),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: _loadSpecies,
//                   child: const Text(
//                     "Retry",
//                     style: TextStyle(color: AppColors.primaryGreen, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }




// ----------------- CHATGPT ----------------------





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../utils/colors.dart'; // Import the new colors file
import '../config.dart';

class SpeciesDropdown extends StatefulWidget {
  final void Function(String speciesId, String speciesName) onSelected;

  const SpeciesDropdown({super.key, required this.onSelected});

  @override
  State<SpeciesDropdown> createState() => _SpeciesDropdownState();
}

class _SpeciesDropdownState extends State<SpeciesDropdown> {
  static const String baseUrl = '${AppConfig.baseUrl}/api/species';

  List<Map<String, dynamic>> _speciesList = [];
  String? _selectedSpeciesId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSpecies();
  }

  Future<void> _fetchSpecies() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl?page=1&limit=50"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data']['species'];

        setState(() {
          _speciesList = data.map((s) {
            return {
              "id": s['speciesId'] ?? s['id'],
              "commonName": s['commonName'] ?? s['common_name'] ?? '',
              "scientificName": s['scientificName'] ?? s['scientific_name'] ?? '',
            };
          }).toList();
          _loading = false;
          _selectedSpeciesId = null;
        });
      } else {
        setState(() {
          _error = "Error: ${response.body}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "⚠️ Failed to load species: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
    }
    if (_error != null) {
      return Text(_error!, style: const TextStyle(color: Colors.red));
    }

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select a Species",
        labelStyle: TextStyle(color: AppColors.subtitleColor),
        border: InputBorder.none,
        filled: false,
      ),
      value: _selectedSpeciesId,
      hint: const Text("Select a species", style: TextStyle(color: AppColors.subtitleColor)),
      items: _speciesList.map((s) {
        return DropdownMenuItem<String>(
          value: s["id"],
          child: Text(
            "${s["commonName"]} (${s["scientificName"]})",
            style: const TextStyle(color: AppColors.textColor),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          final selected = _speciesList.firstWhere((s) => s["id"] == value);
          final commonName = selected["commonName"] ?? "";
          setState(() {
            _selectedSpeciesId = value;
          });
          widget.onSelected(value, commonName); // ✅ pass both ID & Name
        }
      },
      validator: (val) => val == null ? "Please select a species" : null,
      dropdownColor: AppColors.cardBackground,
      iconEnabledColor: AppColors.primaryGreen,
    );
  }
}
