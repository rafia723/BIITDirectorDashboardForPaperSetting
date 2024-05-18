
import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/DATACELL/courseList.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:flutter/material.dart';
class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {

   Future<void> addCourseData(String cCode, String cTitle, String cHours, String status) async {
  try {
    int code = await APIHandler().addCourse(cCode, cTitle, cHours, status);
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(code == 200 ? 'Inserted' : 'Error....'),
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
    }
  } catch (e) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return  AlertDialog(
            title: const Text('Error inserting course data'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }
}

 TextEditingController ccode = TextEditingController();
  TextEditingController ctitle = TextEditingController();
  TextEditingController crhrs = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
        appBar: customAppBar(context: context, title: 'Course Form'),
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
             customTextField(controller: ccode, hintText: 'Enter Course Code...', labelText: 'Course Code', prefixIcon: Icons.code,obscureText: false),
                  customTextField(controller: ctitle, hintText: 'Enter Course Title...', labelText: 'Course Title', prefixIcon: Icons.abc,obscureText: false),
                 customTextField(controller: crhrs, hintText: 'Enter Credit Hours...', labelText: 'Credit Hours', prefixIcon: Icons.hourglass_bottom,obscureText:false),
                 const SizedBox(height: 10),
              customElevatedButton(onPressed: ()async{
                addCourseData(
                    ccode.text,
                    ctitle.text,
                    crhrs.text,
                    'enabled',
                  );
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