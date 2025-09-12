// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController orgIdController = TextEditingController();
//   final TextEditingController blockchainController = TextEditingController();
//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Farmer Registration')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: firstNameController,
//               decoration: const InputDecoration(labelText: 'First Name'),
//             ),
//             TextField(
//               controller: lastNameController,
//               decoration: const InputDecoration(labelText: 'Last Name'),
//             ),
//             // TextField(controller: orgIdController, decoration: const InputDecoration(labelText: 'Organization ID')),
//             TextField(
//               controller: blockchainController,
//               decoration: const InputDecoration(
//                 labelText: 'Blockchain Identity (optional)',
//               ),
//             ),
//             const SizedBox(height: 20),
//             loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : ElevatedButton(
//                     onPressed: () async {
//                       setState(() => loading = true);
//                       try {
//                         const defaultOrganizationId =
//                             "89982bac-c0d0-48a9-be9a-cd93a5502148"; // replace with your desired UUID
//                         await authProvider.register(
//                           email: emailController.text,
//                           password: passwordController.text,
//                           firstName: firstNameController.text,
//                           lastName: lastNameController.text,
//                           organizationId: defaultOrganizationId,
//                           blockchainIdentity: blockchainController.text.isEmpty
//                               ? "none"
//                               : blockchainController.text,
//                           orgType:
//                               "FARMER", // ✅ now correctly passed to backend
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text('Registration successful!')),
//                         );
//                         Navigator.pop(context);
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(e.toString())),
//                         );
//                       } finally {
//                         setState(() => loading = false);
//                       }
//                     },
//                     child: const Text('Register'),
//                   ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               },
//               child: const Text("Already have an account? Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ------------------------------------------ UI BY CHATGPT ------------------------------------------




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
  final TextEditingController blockchainController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Farmer Registration',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: blockchainController,
                  decoration: InputDecoration(
                    labelText: 'Blockchain Identity (optional)',
                    prefixIcon: const Icon(Icons.link, color: Color(0xFF2E7D32)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                loading
                    ? const CircularProgressIndicator(color: Color(0xFF2E7D32))
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            setState(() => loading = true);
                            try {
                              const defaultOrganizationId =
                                  "89982bac-c0d0-48a9-be9a-cd93a5502148";
                              await authProvider.register(
                                email: emailController.text,
                                password: passwordController.text,
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                organizationId: defaultOrganizationId,
                                blockchainIdentity: blockchainController.text.isEmpty
                                    ? "none"
                                    : blockchainController.text,
                                orgType: "FARMER",
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Registration successful!')),
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
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
