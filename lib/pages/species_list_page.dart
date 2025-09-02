import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SpeciesListPage extends StatefulWidget {
  @override
  _SpeciesListPageState createState() => _SpeciesListPageState();
}

class _SpeciesListPageState extends State<SpeciesListPage> {
  List<dynamic> species = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.fetchSpeciesRules();
      setState(() {
        species = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Species'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () => Navigator.pushNamed(context, '/queue'),
          )
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : ListView.builder(
                  itemCount: species.length,
                  itemBuilder: (ctx, i) {
                    final s = species[i];
                    return ListTile(
                      title: Text(s['commonName'] ?? s['speciesCode']),
                      subtitle: Text(s['scientificName'] ?? ''),
                      onTap: () {
                        Navigator.pushNamed(context, '/collect',
                            arguments: s);
                      },
                    );
                  }),
    );
  }
}
