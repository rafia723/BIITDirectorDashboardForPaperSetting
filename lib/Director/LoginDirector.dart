import 'package:biit_directors_dashbooard/Director/director.dart';
import 'package:flutter/material.dart';

class LoginDirector extends StatefulWidget {
  const LoginDirector({super.key});

  @override
  State<LoginDirector> createState() => _LoginDirectorState();
}
TextEditingController username =TextEditingController();
TextEditingController password =TextEditingController();
class _LoginDirectorState extends State<LoginDirector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png', // Replace with the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100, // Adjust the width of the circular logo
                  height: 100, // Adjust the height of the circular logo
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Adjust the border color
                      width: 1.0, // Adjust the border width
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.jpeg'), // Replace with the path to your logo image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Username',
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                       floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const Director(),
                      ),
                    );
                  },
                 child: const Text('Login',style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}