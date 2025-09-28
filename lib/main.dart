import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/collection_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  try {
    await authProvider.fetchProfile(); // Load user if token exists
  } catch (_) {}

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider), // existing
        ChangeNotifierProvider(create: (_) => CollectionProvider(authProvider)), // 👈 add this
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.user == null
              ? const LoginScreen()
              : const HomeScreen();
        },
      ),
    );
  }
}
