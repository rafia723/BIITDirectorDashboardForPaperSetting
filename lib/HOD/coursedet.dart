
import 'package:biit_directors_dashbooard/HOD/CourseAssignedToFacultyMembers.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:flutter/material.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  List<dynamic> clist = [];

  @override
  void initState() {
    super.initState();
    loadCourse();
  }

  TextEditingController search = TextEditingController();



   Future<void> searchCourse(String query) async {
    try {
      if (query.isEmpty) {
        loadCourse();
        return;
      }
        clist = await APIHandler().searchCourseWithEnabledStatus(query);
        setState(() {});
      
    } catch (e) {
       if(mounted){
        showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> loadCourse() async {
    try {
     
        clist = await APIHandler().loadCourseWithEnabledStatus();
        setState(() {});
      
    } catch (e) {
      if(mounted){
showErrorDialog(context, e.toString());
      }
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context, title: 'Course Details'),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: search,
                      onChanged: (value) {
                        searchCourse(value);
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        labelText: 'Search Course',
                        labelStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: clist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                        child: GestureDetector(
                          onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  AssignedtoDetails(
                                      courseTitle: clist[index]['c_title'],
                                      ccode: clist[index]['c_code'],
                                      cid: clist[index]['c_id'],
                                    ),
                                  ),
                                );
                          },
                          child: ListTile(
                            title: Text(
                              clist[index]['c_title'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  clist[index]['c_code'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  AssignedtoDetails(
                                    courseTitle: clist[index]['c_title'],
                                    ccode: clist[index]['c_code'],
                                     cid: clist[index]['c_id'],
                                    ),
                                  ),
                                );
                                  },
                                  icon: const Icon(Icons.remove_red_eye),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
