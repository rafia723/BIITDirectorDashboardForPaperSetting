import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/courseList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {

    Future<int> addCourse(String cCode,String cTitle,String cHours,String status)async
  {
String url="${APIHandler().apiUrl}Course/addCourse";
    var courseobj={
      'c_code':cCode,
      'c_title':cTitle,
      'cr_hours':cHours,
      'status':status
    };
    var json=jsonEncode(courseobj);
    Uri uri=Uri.parse(url);
    var response =await  http.post(uri,body: json,headers:{"Content-Type":"application/json; charset=UTF-8"});
   return response.statusCode;
  }

 TextEditingController ccode = TextEditingController();
  TextEditingController ctitle = TextEditingController();
  TextEditingController crhrs = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Course Form',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CourseDetail()));
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
             customTextField(controller: ccode, hintText: 'Enter Course Code...', labelText: 'Course Code', prefixIcon: Icons.code,obscureText: false),
                  customTextField(controller: ctitle, hintText: 'Enter Course Title...', labelText: 'Course Title', prefixIcon: Icons.abc,obscureText: false),
                 customTextField(controller: crhrs, hintText: 'Enter Credit Hours...', labelText: 'Credit Hours', prefixIcon: Icons.hourglass_bottom,obscureText:false),
                 const SizedBox(height: 10),
              customElevatedButton(onPressed: ()async{
                int code = await addCourse(
                    ccode.text,
                    ctitle.text,
                    crhrs.text,
                    'enabled',
                  );
                  if (code == 200) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(title: Text('Inserted'),);
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(title: Text('Error....'),);
                      },
                    );
                  }
               // Close the dialog after 2 seconds
            if (code == 200) {
              Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                 builder: (context) => const CourseDetail(),
                   ),
               );
              });
              }
              },
              buttonText: 'Add'),
          ],
        ),
      )
        ]
      )
    );
  }
}