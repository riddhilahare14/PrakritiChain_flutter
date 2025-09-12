// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/collection_provider.dart';
// import 'login_screen.dart';
// import 'new_collection_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // Schedule fetchCollections after the first frame to avoid setState during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadCollections();
//     });
//   }

//   Future<void> _loadCollections() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final collectionProvider =
//         Provider.of<CollectionProvider>(context, listen: false);

//     try {
//       await collectionProvider.fetchCollections();
//     } catch (e) {
//       // Handle fetch error if needed
//       debugPrint("Error fetching collections: $e");
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _refreshCollections() async {
//     final collectionProvider =
//         Provider.of<CollectionProvider>(context, listen: false);
//     await collectionProvider.fetchCollections();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     // Show loading until user is ready and collections fetched
//     if (authProvider.user == null || _isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final collectionProvider = Provider.of<CollectionProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Farmer Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               authProvider.logout();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Welcome + Add button
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Welcome, ${authProvider.user!.firstName}!',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.add),
//                   label: const Text("Add New Collection"),
//                   onPressed: () async {
//                     final added = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const NewCollectionScreen()),
//                     );

//                     if (added == true) {
//                       // Refresh collections safely after adding
//                       await _refreshCollections();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Collections list
//           Expanded(
//             child: collectionProvider.collections.isEmpty
//                 ? const Center(child: Text("No collections yet"))
//                 : RefreshIndicator(
//                     onRefresh: _refreshCollections,
//                     child: ListView.builder(
//                       itemCount: collectionProvider.collections.length,
//                       itemBuilder: (context, index) {
//                         final collection =
//                             collectionProvider.collections[index];

//                         final dateStr = collection['collectionDate'];
//                         final date = dateStr != null
//                             ? DateTime.parse(dateStr).toLocal()
//                             : null;

//                         return Card(
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           child: ListTile(
//                             title: Text(
//                                 // "Species: ${collection['herbSpeciesId'] ?? 'N/A'}"),
//                                 "Species: ${collection['speciesName'] ?? 'N/A'}"),
//                             subtitle: Text(
//                                 "Quantity: ${collection['quantity'] ?? 0} kg"),
//                             trailing: Text(date != null
//                                 ? "${date.day}/${date.month}/${date.year}"
//                                 : ""),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// ------------------------------------------ UI BY CLAUDE ------------------------------------------





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/collection_provider.dart';
// import 'login_screen.dart';
// import 'new_collection_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   bool _isLoading = true;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );
    
//     // Schedule fetchCollections after the first frame to avoid setState during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadCollections();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadCollections() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final collectionProvider =
//         Provider.of<CollectionProvider>(context, listen: false);

//     try {
//       await collectionProvider.fetchCollections();
//       _animationController.forward();
//     } catch (e) {
//       // Handle fetch error if needed
//       debugPrint("Error fetching collections: $e");
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _refreshCollections() async {
//     final collectionProvider =
//         Provider.of<CollectionProvider>(context, listen: false);
//     await collectionProvider.fetchCollections();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     // Show loading until user is ready and collections fetched
//     if (authProvider.user == null || _isLoading) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFE8F5E9),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.2),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: const CircularProgressIndicator(
//                   color: Color(0xFF2E7D32),
//                   strokeWidth: 3,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Loading AyuTrace...',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFF2E7D32),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     final collectionProvider = Provider.of<CollectionProvider>(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFE8F5E9),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF2E7D32),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.eco,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'AyuTrace',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 foregroundColor: Colors.white,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.logout, size: 18),
//               label: const Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//               ),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       title: Row(
//                         children: [
//                           Icon(
//                             Icons.logout,
//                             color: Colors.red[400],
//                           ),
//                           const SizedBox(width: 8),
//                           const Text('Confirm Logout'),
//                         ],
//                       ),
//                       content: const Text('Are you sure you want to logout?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red[400],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             authProvider.logout();
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (_) => const LoginScreen()),
//                             );
//                           },
//                           child: const Text(
//                             'Logout',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             // Welcome Header Card
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF66BB6A),
//                     const Color(0xFF4CAF50),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.green.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Welcome back,',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${authProvider.user!.firstName}!',
//                           style: const TextStyle(
//                             fontSize: 24,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${collectionProvider.collections.length} Collections',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Add Collection Button
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 4,
//                 ),
//                 icon: const Icon(Icons.add_circle_outline, color: Colors.white),
//                 label: const Text(
//                   "Add New Collection",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onPressed: () async {
//                   final added = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => const NewCollectionScreen()),
//                   );

//                   if (added == true) {
//                     // Refresh collections safely after adding
//                     await _refreshCollections();
//                   }
//                 },
//               ),
//             ),

//             // Collections Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2E7D32).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.inventory_2,
//                       color: Color(0xFF2E7D32),
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Your Collections',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2E7D32),
//                     ),
//                   ),
//                   const Spacer(),
//                   if (collectionProvider.collections.isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF66BB6A),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '${collectionProvider.collections.length}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             // Collections List
//             Expanded(
//               child: collectionProvider.collections.isEmpty
//                   ? Center(
//                       child: Container(
//                         padding: const EdgeInsets.all(32),
//                         margin: const EdgeInsets.all(32),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.green.withOpacity(0.1),
//                               blurRadius: 12,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF2E7D32).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: const Icon(
//                                 Icons.eco,
//                                 size: 48,
//                                 color: Color(0xFF2E7D32),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'No Collections Yet',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF2E7D32),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Start your ayurvedic journey by adding your first collection!',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : RefreshIndicator(
//                       color: const Color(0xFF2E7D32),
//                       backgroundColor: Colors.white,
//                       onRefresh: _refreshCollections,
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: collectionProvider.collections.length,
//                         itemBuilder: (context, index) {
//                           final collection = collectionProvider.collections[index];
//                           final dateStr = collection['collectionDate'];
//                           final date = dateStr != null
//                               ? DateTime.parse(dateStr).toLocal()
//                               : null;

//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.green.withOpacity(0.1),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               leading: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       const Color(0xFF66BB6A).withOpacity(0.2),
//                                       const Color(0xFF4CAF50).withOpacity(0.2),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(
//                                   Icons.local_florist,
//                                   color: Color(0xFF2E7D32),
//                                   size: 24,
//                                 ),
//                               ),
//                               title: Text(
//                                 collection['speciesName'] ?? 'Unknown Species',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Color(0xFF2E7D32),
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.scale,
//                                         size: 16,
//                                         color: Color(0xFF66BB6A),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         '${collection['quantity'] ?? 0} kg',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: Color(0xFF66BB6A),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   if (date != null) ...[
//                                     const SizedBox(height: 4),
//                                     Row(
//                                       children: [
//                                         const Icon(
//                                           Icons.calendar_today,
//                                           size: 16,
//                                           color: Colors.grey,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           "${date.day}/${date.month}/${date.year}",
//                                           style: TextStyle(
//                                             color: Colors.grey[600],
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                               trailing: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[100],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// ------------------------------------------ UI BY GEMINI ------------------------------------------


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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCollections();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCollections() async {
    setState(() {
      _isLoading = true;
    });

    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);

    try {
      await collectionProvider.fetchCollections();
      _animationController.forward();
    } catch (e) {
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

    // Color Palette: Green and Off-White/Gray
    const Color primaryGreen = Color(0xFF2E7D32);
    const Color accentGreen = Color(0xFF66BB6A);
    const Color lightBackground = Color(0xFFF9F9F9); // Soft gray/off-white
    const Color cardBackground = Colors.white;
    const Color textColor = Color(0xFF424242);
    const Color subtitleColor = Color(0xFF757575);

    if (authProvider.user == null || _isLoading) {
      return Scaffold(
        backgroundColor: lightBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  color: primaryGreen,
                  strokeWidth: 4,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading AyuTrace...',
                style: TextStyle(
                  fontSize: 18,
                  color: primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final collectionProvider = Provider.of<CollectionProvider>(context);

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGreen,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'AyuTrace',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Confirm Logout'),
                        ],
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel', style: TextStyle(color: primaryGreen)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            authProvider.logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Logout', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${authProvider.user!.firstName}!',
                          style: const TextStyle(
                            fontSize: 24,
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${collectionProvider.collections.length} Collections',
                            style: const TextStyle(
                              fontSize: 12,
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: primaryGreen,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Add Collection Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  "Add New Collection",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  final added = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NewCollectionScreen()),
                  );
                  if (added == true) {
                    await _refreshCollections();
                  }
                },
              ),
            ),

            // Collections Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.inventory_2, color: primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Your Collections',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const Spacer(),
                  if (collectionProvider.collections.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${collectionProvider.collections.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Collections List
            Expanded(
              child: collectionProvider.collections.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.eco,
                                size: 48,
                                color: primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Collections Yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start your ayurvedic journey by adding your first collection!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: primaryGreen,
                      backgroundColor: cardBackground,
                      onRefresh: _refreshCollections,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: collectionProvider.collections.length,
                        itemBuilder: (context, index) {
                          final collection = collectionProvider.collections[index];
                          final dateStr = collection['collectionDate'];
                          final date = dateStr != null
                              ? DateTime.parse(dateStr).toLocal()
                              : null;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primaryGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_florist,
                                  color: primaryGreen,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                collection['speciesName'] ?? 'Unknown Species',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.scale,
                                        size: 16,
                                        color: accentGreen,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${collection['quantity'] ?? 0} kg',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: accentGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (date != null) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: subtitleColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${date.day}/${date.month}/${date.year}",
                                          style: const TextStyle(
                                            color: subtitleColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: lightBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: subtitleColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}