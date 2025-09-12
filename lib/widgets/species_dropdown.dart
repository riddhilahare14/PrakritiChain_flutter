// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import '../providers/auth_provider.dart';

// class SpeciesDropdown extends StatefulWidget {
//   final void Function(String?) onSelected; // Callback with selected speciesId

//   const SpeciesDropdown({super.key, required this.onSelected});

//   @override
//   State<SpeciesDropdown> createState() => _SpeciesDropdownState();
// }

// class _SpeciesDropdownState extends State<SpeciesDropdown> {
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
//         Uri.parse("http://10.0.2.2:3000/api/species?page=1&limit=50"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         final List<dynamic> data = jsonData['data']['species'];

//         setState(() {
//           _speciesList = data.map((s) {
//             return {
//               "id": s['speciesId'] ?? s['id'], // always UUID
//               "commonName": s['commonName'] ?? s['common_name'] ?? '',
//               "scientificName": s['scientificName'] ?? s['scientific_name'] ?? '',
//             };
//           }).toList();
//           _loading = false;
//           _selectedSpeciesId = null; // reset selection on reload
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
//     if (_loading) return const Center(child: CircularProgressIndicator());
//     if (_error != null) return Text(_error!, style: const TextStyle(color: Colors.red));

//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(labelText: "Select a Species"),
//       value: _selectedSpeciesId,
//       hint: const Text("Select a species"),
//       items: _speciesList.map((s) {
//         return DropdownMenuItem<String>(
//           value: s["id"], // keep UUID string
//           child: Text("${s["commonName"]} (${s["scientificName"]})"),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedSpeciesId = value;
//         });
//         widget.onSelected(value);
//       },
//       validator: (val) => val == null ? "Please select a species" : null,
//     );
//   }
// }


// ------------------------------------------ UI BY GEMINI ------------------------------------------



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../utils/colors.dart'; // Import the new colors file

class SpeciesDropdown extends StatefulWidget {
  final void Function(String?) onSelected;

  const SpeciesDropdown({super.key, required this.onSelected});

  @override
  State<SpeciesDropdown> createState() => _SpeciesDropdownState();
}

class _SpeciesDropdownState extends State<SpeciesDropdown> {
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
        Uri.parse("http://10.0.2.2:3000/api/species?page=1&limit=50"),
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
          child: Text("${s["commonName"]} (${s["scientificName"]})", style: const TextStyle(color: AppColors.textColor)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpeciesId = value;
        });
        widget.onSelected(value);
      },
      validator: (val) => val == null ? "Please select a species" : null,
      dropdownColor: AppColors.cardBackground,
      iconEnabledColor: AppColors.primaryGreen,
    );
  }
}