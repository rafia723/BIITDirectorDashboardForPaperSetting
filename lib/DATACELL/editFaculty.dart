import 'dart:convert';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/facultyList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditFaculty extends StatefulWidget {
  int fid;
  dynamic data;
  EditFaculty(this.fid, this.data, {Key? key}) : super(key: key);

  @override
  State<EditFaculty> createState() => _EditFacultyState();
}

class _EditFacultyState extends State<EditFaculty> {
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
   String status = 'enabled'; // Default status

Future<int> updateFaculty(int id, Map<String, dynamic> facultyData) async {
  Uri url = Uri.parse('${APIHandler().apiUrl}Faculty/editFaculty/$id');
  try {
    var facultyJson = jsonEncode(facultyData);
    var response = await http.put(
      url,
      body: facultyJson,
      headers: {"Content-Type": "application/json"},
    );
      return response.statusCode;
  } catch (error) {
    throw Exception('Error: $error');
  }
}
  @override
  void initState() {
    super.initState();
    // Initialize text controllers with data from the provided 'data'
    name.text = widget.data['f_name'];
    username.text = widget.data['username'];
    password.text = widget.data['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Edit Faculty',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/datacell.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
      Padding(
        padding: const EdgeInsets.all(8.0),
         child: SafeArea(
             child: Column(
               children: [
                  customTextField(controller: name, hintText: 'Enter Name...', labelText: 'Name', prefixIcon: Icons.abc,obscureText: false),
                  customTextField(controller: username, hintText: 'Enter Username...', labelText: 'Username', prefixIcon: Icons.person,obscureText: false),
                 customTextField(controller: password, hintText: 'Password...', labelText: 'Password', prefixIcon: Icons.lock,obscureText:true),
                 const SizedBox(height: 10),
                 customElevatedButton(onPressed: () async {
                      int facultyId = widget.fid; // Use the faculty ID provided in the widget
                     Map<String, dynamic> facultyData = {
                       "f_name": name.text,
                       "username": username.text,
                       "password": password.text,
                       "status": status,
                     };
                     int code = await updateFaculty(facultyId, facultyData);
                     showDialog(
                       context: context,
                       builder: (context) {
                         return AlertDialog(
                           title: Text(code == 200 ? 'Updated' : 'Error...'),
                           
                         );
                       },
                     );
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
                   }, buttonText: 'Update'),
               ],
             ),
           ),
      ),
    ],
    ),
    );
  }
}