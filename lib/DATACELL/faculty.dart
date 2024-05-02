import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'facultyList.dart';

class FacultyForm extends StatefulWidget {
  const FacultyForm({super.key});

  @override
  State<FacultyForm> createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  List<dynamic> flist = [];
  Future<int> addFaculty(
      String name, String username, String password, String status) async {
    String url = "${APIHandler().apiUrl}Faculty/addFaculty";
    var facultyobj = {
      'f_name': name,
      'username': username,
      'password': password,
      'status': status
    };
    var json = jsonEncode(facultyobj);
    Uri uri = Uri.parse(url);
    var response = await http.post(uri,
        body: json,
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    return response.statusCode;
  }

  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController search = TextEditingController();
  Color customColor = const Color.fromARGB(255, 78, 223, 180);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'Faculty Form'),
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                customTextField(
                    controller: name,
                    hintText: 'Enter Name...',
                    labelText: 'Name',
                    prefixIcon: Icons.abc,
                    obscureText: false),
                customTextField(
                    controller: username,
                    hintText: 'Enter Username...',
                    labelText: 'Username',
                    prefixIcon: Icons.person,
                    obscureText: false),
                customTextField(
                    controller: password,
                    hintText: 'Password...',
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: true),
                const SizedBox(height: 10),
                customElevatedButton(
                    onPressed: () async {
                      int code = await addFaculty(
                        name.text,
                        username.text,
                        password.text,
                        'enabled',
                      );
                      if (code == 200) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Inserted'),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Error....'),
                            );
                          },
                        );
                      }
                      // Close the dialog after 2 seconds
                      if (code == 200) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FacultyDetails(),
                            ),
                          );
                        });
                      }
                    },
                    buttonText: 'Add'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
