// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:biit_directors_dashbooard/HOD/CourseAssignedToFacultyMembers.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';
import 'package:http/http.dart' as http;
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

  Future<void> searchCourses(String query) async {
    try {
      if (query.isEmpty) {
        loadCourse();
        return;
      }
      Uri url = Uri.parse(
          '${APIHandler().apiUrl}Course/searchCourseWithEnabledStatus?search=$query');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to search courses');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error searching courses'),
          );
        },
      );
    }
  }

  Future<void> loadCourse() async {
    try {
      Uri uri =
          Uri.parse('${APIHandler().apiUrl}Course/getCourseWithEnabledStatus');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        clist = jsonDecode(response.body);
        setState(() {});
      } else {
        throw Exception('Failed to load course');
      }
    } catch (e) {
      if(mounted){
 showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error loading course'),
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
                        searchCourses(value);
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
