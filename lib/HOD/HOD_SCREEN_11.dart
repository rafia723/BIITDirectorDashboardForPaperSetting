import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/HOD/hod.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignRole extends StatefulWidget {
  const AssignRole({super.key});

  @override
  State<AssignRole> createState() => _AssignRoleState();
}

class _AssignRoleState extends State<AssignRole> {
  List<dynamic> clist = [];
  List<dynamic> assignedToList = [];
  String? selectedCourse; // Nullable initially
   int selectedRadio=0;

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

  Future<void> loadAssignedToCourses(int id) async {
    try {
      Uri uri =
          Uri.parse("${APIHandler().apiUrl}AssignedCourses/getAssignedTo/$id");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        assignedToList = jsonDecode(response.body);
        int seniorTeacherIndex = assignedToList.indexWhere((teacher) => teacher['role'] == 'Senior');
   //   Set the index as the selectedRadio value
      
      if (seniorTeacherIndex != -1) {
        setState(() {
          selectedRadio = seniorTeacherIndex;
        });
      } else {
        // If no senior teacher is found, reset the selectedRadio value
        setState(() {
          selectedRadio = -1;
        });
      }
        setState(() {});
      } else if (response.statusCode == 404) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Data not found for the given id'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                  'Failed to load assigned Faculty. Please try again later.'),
            );
          },
        );
      }
   
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('An error occurred. Please try again later.'),
          );
        },
      );
    }
  }

  Future<void> updateRole(int cid, int fid) async {
    Uri url =
        Uri.parse('${APIHandler().apiUrl}AssignedCourses/editRole/$cid/$fid');
    try {
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
      );
     if(response.statusCode==200){
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Role Changed'),
            );
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error changing Role of Faculty'),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 10,
        title: const Text(
          'Assign Role',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HOD()));
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/HOD.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Course:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                       constraints: const BoxConstraints(maxWidth: 350),
                      decoration: BoxDecoration(
                        color: Colors.white, // Set background color to white
                        borderRadius: BorderRadius.circular(
                            5), // Optional: Add border radius
                      ),
                      child: DropdownButton<String>(
                        hint: const Text(' Select Course '),
                       isExpanded: true,
                        elevation: 9,
                        value: selectedCourse,
                        items: clist.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['c_title'],
                            onTap: () {
                              setState(() {
                                selectedCourse = e['c_title'];
                                assignedToList
                                    .clear(); // Clear the list when a new course is selected
                                loadAssignedToCourses(e['c_id']);
                              });
                            },
                            child: Text(
                              e['c_title'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCourse = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Center(
                  child: Text(
                    'SENIOR TEACHER', // Show selected faculty
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Expanded(
                  child: assignedToList.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ), // Show loading indicator while data is being fetched
                        )
                      : ListView.builder(
                          itemCount: assignedToList.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white.withOpacity(0.8),
                                child: ListTile(
                                    title: Text(
                                      assignedToList[index]['TeacherName'],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio(
                                          activeColor: Colors.green,
                                          value:
                                              index,
                                          groupValue:
                                              selectedRadio, // You should set this to a value that corresponds to the selected radio button
                                          onChanged: (val) {
                                            setState(() {
                                              selectedRadio=val as int;
                                              updateRole(assignedToList[selectedRadio]['c_id'],assignedToList[selectedRadio]['f_id'] );
                                            });
                                          },
                                        ),
                                      ],
                                    )));
                          }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
