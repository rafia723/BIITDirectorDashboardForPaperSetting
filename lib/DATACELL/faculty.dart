
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';

import 'facultyList.dart';

class FacultyForm extends StatefulWidget {
  const FacultyForm({super.key});

  @override
  State<FacultyForm> createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  Future<void> addFacultyData(String name, String username, String password, String status) async {
   try {
     dynamic code=await APIHandler().addFaculty(name, username, password, status);
     if(mounted){
       showDialog(
           context: context,
           builder: (context) {
            return  AlertDialog(
               title: Text(code==200? 'Inserted': 'Error....'),
                 );
               },
           );
           if(code==200){
            Future.delayed(const Duration(seconds: 1), () {
                Navigator.push(
                   context,
                  MaterialPageRoute(
                   builder: (context) => const FacultyDetails(),
                            ),
                          );
                        });
           }
     }
   } catch (e) {
      if(mounted){
       showDialog(
           context: context,
           builder: (context) {
            return   AlertDialog(
               title: const Text('Error inserting faculty'),
               content: Text(e.toString()),
                 );
               },
           );
      }
     
   }
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
                    onPressed: ()  async{
                     addFacultyData(name.text, username.text, password.text, 'enabled');
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
