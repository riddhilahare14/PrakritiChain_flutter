import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/collection_provider.dart';
import 'login_screen.dart';
import 'new_collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Schedule fetchCollections after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCollections();
    });
  }

  Future<void> _loadCollections() async {
    setState(() {
      _isLoading = true;
    });

    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);

    try {
      await collectionProvider.fetchCollections();
    } catch (e) {
      // Handle fetch error if needed
      debugPrint("Error fetching collections: $e");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCollections() async {
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    await collectionProvider.fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show loading until user is ready and collections fetched
    if (authProvider.user == null || _isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final collectionProvider = Provider.of<CollectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome + Add button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome, ${authProvider.user!.firstName}!',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Collection"),
                  onPressed: () async {
                    final added = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NewCollectionScreen()),
                    );

                    if (added == true) {
                      // Refresh collections safely after adding
                      await _refreshCollections();
                    }
                  },
                ),
              ],
            ),
          ),

          // Collections list
          Expanded(
            child: collectionProvider.collections.isEmpty
                ? const Center(child: Text("No collections yet"))
                : RefreshIndicator(
                    onRefresh: _refreshCollections,
                    child: ListView.builder(
                      itemCount: collectionProvider.collections.length,
                      itemBuilder: (context, index) {
                        final collection =
                            collectionProvider.collections[index];

                        final dateStr = collection['collectionDate'];
                        final date = dateStr != null
                            ? DateTime.parse(dateStr).toLocal()
                            : null;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                                // "Species: ${collection['herbSpeciesId'] ?? 'N/A'}"),
                                "Species: ${collection['speciesName'] ?? 'N/A'}"),
                            subtitle: Text(
                                "Quantity: ${collection['quantity'] ?? 0} kg"),
                            trailing: Text(date != null
                                ? "${date.day}/${date.month}/${date.year}"
                                : ""),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
