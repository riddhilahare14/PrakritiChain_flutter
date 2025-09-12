import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController orgIdController = TextEditingController();
  final TextEditingController blockchainController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            // TextField(controller: orgIdController, decoration: const InputDecoration(labelText: 'Organization ID')),
            TextField(
              controller: blockchainController,
              decoration: const InputDecoration(
                labelText: 'Blockchain Identity (optional)',
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      try {
                        const defaultOrganizationId =
                            "89982bac-c0d0-48a9-be9a-cd93a5502148"; // replace with your desired UUID
                        await authProvider.register(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          organizationId: defaultOrganizationId,
                          blockchainIdentity: blockchainController.text.isEmpty
                              ? "none"
                              : blockchainController.text,
                          orgType:
                              "FARMER", // ✅ now correctly passed to backend
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Registration successful!')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        setState(() => loading = false);
                      }
                    },
                    child: const Text('Register'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
