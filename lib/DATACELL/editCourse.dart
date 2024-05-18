
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/courseList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
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
  
  @override
  void initState() {
    super.initState();
    // Initialize text controllers with data from the provided 'data'
    ccode.text = widget.data['c_code'];
    ctitle.text = widget.data['c_title'];
    crhrs.text = widget.data['cr_hours'].toString();
  }

Future<void> updateCourseData(int id, Map<String, dynamic> courseData) async {
  try {
    int code=await APIHandler().updateCourse(id, courseData);
            if(code==200){
             if(mounted){
              showDialog(
                     context: context,
                     builder: (context) {
                       return const AlertDialog(
                         title: Text('Updated'),
                       );
                     },
                   );
              Future.delayed(const Duration(seconds: 1), () {
                     Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const CourseDetail(),
                  ),
              ); 
             });
                   }
            }else if(code!=500&&code!=200){
              throw Exception('${ccode.text} already exists in the database.');
            }
  } catch (e) {
     if(mounted){
              showDialog(
                     context: context,
                     builder: (context) {
                       return  AlertDialog(
                         title: const Text('Error updating course'),
                         content: Text(e.toString()),
                       );
                     },
                   );
     }
  }
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
                  updateCourseData(cId, cData);
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