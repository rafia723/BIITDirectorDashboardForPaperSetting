import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/faculty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginFaculty extends StatefulWidget {
  const LoginFaculty({super.key});

  @override
  State<LoginFaculty> createState() => _LoginFacultyState();
}
TextEditingController username =TextEditingController();
TextEditingController password =TextEditingController();




class _LoginFacultyState extends State<LoginFaculty> {
 
Future<void> loginFaculty(BuildContext context) async {
  final response = await http.post(
    Uri.parse("${APIHandler().apiUrl}Faculty/loginFaculty"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username.text.trim(),
      'password': password.text.trim(),
    }),
  );

  if (response.statusCode == 200) {
     Map<String, dynamic> responseData = jsonDecode(response.body);
      int fid = responseData['fid']; // Extract fid from response
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Faculty(facultyname: username.text, fid: fid),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Login Failed'),
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/Faculty.png', // Replace with the path to your background image
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
                const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white)),
                const SizedBox(height: 20),
                TextFormField(

                  controller: username,
                  decoration: InputDecoration(
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
                   loginFaculty(context);
                  },
                  child: const Text('Login'),
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