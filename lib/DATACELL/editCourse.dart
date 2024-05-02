import 'dart:convert';
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/courseList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditCourse extends StatefulWidget {
  int cid;
  dynamic data;

  EditCourse(this.cid, this.data, {Key? key}) : super(key: key);

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  TextEditingController ccode = TextEditingController();
  TextEditingController ctitle = TextEditingController();
  TextEditingController crhrs = TextEditingController();
    String status = 'enabled'; // Default status
  

Future<int> updateCourse(int id, Map<String, dynamic> CourseData) async {
  Uri url = Uri.parse('${APIHandler().apiUrl}Course/editCourse/$id');
  try {
    var courseJson = jsonEncode(CourseData);
    var response = await http.put(
      url,
      body: courseJson,
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
    ccode.text = widget.data['c_code'];
    ctitle.text = widget.data['c_title'];
    crhrs.text = widget.data['cr_hours'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     appBar: customAppBar(context: context, title: 'Edit Course'),
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
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
               customTextFieldWithoutLabelAndHint(controller: ccode, prefixIcon: Icons.code,obscureText: false),
                customTextFieldWithoutLabelAndHint(controller: ctitle, prefixIcon: Icons.abc,obscureText: false),
               customTextFieldWithoutLabelAndHint(controller: crhrs,prefixIcon: Icons.hourglass_bottom,obscureText:false),
               const SizedBox(height: 10),
           
              customElevatedButton(onPressed: () async {
                    int cId = widget.cid; // Use the faculty ID provided in the widget
                   Map<String, dynamic> cData = {
                      "c_code": ccode.text,
                    "c_title": ctitle.text,
                    "cr_hours": crhrs.text,
                     "status": status,
                   };
                   int code = await updateCourse(cId, cData);
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
                builder: (context) => const CourseDetail(),
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