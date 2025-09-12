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
//         Uri.parse("http://10.0.2.2:3000/api/species?page=1&limit=50"), // correct route
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         // Assuming backend returns data as { data: { species: [...] } }
//         final List<dynamic> data = jsonData['data']['species'];

//         setState(() {
//           _speciesList = data.map((s) {
//             return {
//               "id": s['speciesId'] ?? s['id'], // Prisma uses speciesId
//               "commonName": s['commonName'] ?? s['common_name'] ?? '',
//               "scientificName": s['scientificName'] ?? s['scientific_name'] ?? '',
//             };
//           }).toList();
//           _loading = false;
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
//           value: s["id"].toString(), // always a string
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


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class SpeciesDropdown extends StatefulWidget {
  final void Function(String?) onSelected; // Callback with selected speciesId

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
              "id": s['speciesId'] ?? s['id'], // always UUID
              "commonName": s['commonName'] ?? s['common_name'] ?? '',
              "scientificName": s['scientificName'] ?? s['scientific_name'] ?? '',
            };
          }).toList();
          _loading = false;
          _selectedSpeciesId = null; // reset selection on reload
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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Text(_error!, style: const TextStyle(color: Colors.red));

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: "Select a Species"),
      value: _selectedSpeciesId,
      hint: const Text("Select a species"),
      items: _speciesList.map((s) {
        return DropdownMenuItem<String>(
          value: s["id"], // keep UUID string
          child: Text("${s["commonName"]} (${s["scientificName"]})"),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpeciesId = value;
        });
        widget.onSelected(value);
      },
      validator: (val) => val == null ? "Please select a species" : null,
    );
  }
}
