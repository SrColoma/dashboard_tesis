
import 'package:dashboard_tesis/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('D A S H B O A R D'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _signInWithEmailAndPassword(context, _passwordController.text.trim());
                },
                child: const Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                child: const Text('bypass'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context, String password) async {
    try {
      final String emailAddress = 'jctoala03@gmail.com';
      print(password);
      final UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      

      print('Inicio de sesión exitoso: ${credential.user!.email}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso'),backgroundColor: Colors.green,),
        // dirigir a la pagina home
      );
      // MaterialPageRoute(builder: (context) => const Home());
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña incorrecta'),backgroundColor: Colors.red,),
      );
    }
  }
}



      // Contrasena123!