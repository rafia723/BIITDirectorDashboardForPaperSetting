import 'dart:convert';

import 'package:biit_directors_dashbooard/API/api.dart';
import 'package:biit_directors_dashbooard/FACULTY/courseview.dart';
import 'package:biit_directors_dashbooard/FACULTY/notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Faculty extends StatefulWidget {
  final String facultyname;
  final int fid;

  const Faculty({Key? key, required this.facultyname, required this.fid})
      : super(key: key);
  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  Color customColor = const Color.fromARGB(255, 78, 223, 180);

  List<dynamic> aclist = [];
  Future<void> loadAssignedCourses(int id) async {
    try {
      Uri uri = Uri.parse(
          "${APIHandler().apiUrl}AssignedCourses/getAssignedCourses/$id");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        aclist = jsonDecode(response.body);
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
                  'Failed to load assigned courses. Please try again later.'),
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

  Widget _buildCourseButton(Map<String, dynamic> course) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CourseView(
                  courseName: course['c_title'] ?? 'No Title Available',
                  ccode: course['c_code'] ?? 'No Title Available',
                  fname: widget.facultyname,
                  fid: widget.fid,
                  role: course['role'],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor,
            fixedSize: const Size(170, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          child: Text(
            course['c_title'] ?? 'No Title Available',
            style: const TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          course['c_code'] ?? 'No Title Available',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
         const SizedBox(height: 20,),
      ],
    );
  }

  @override
  void initState() {
    loadAssignedCourses(widget.fid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Faculty Dashboard',
          style: TextStyle(
              fontSize: 21.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
       leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>  Faculty(),
            //   ),
            // );
          },
        ),
        actions: [
          // Add your notification icon or message box widget here
          IconButton(
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ), // Replace with your icon or message box widget
            onPressed: () {
              // Handle the notification icon or message box click event
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Notifications(facultyname: widget.facultyname,fid: widget.fid,),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.timer,
              color: Colors.white,
            ), // Replace with your icon or message box widget
            onPressed: () {
              // Handle the notification icon or message box click event
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const Notifications(),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Faculty.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 100),
                Text(
                  'Welcome, ${widget.facultyname}!',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(height: 80),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: (aclist.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int firstIndex = index * 2;
                        int secondIndex = firstIndex + 1;

                        // Check if the second index is within the length of the list
                        bool hasSecond = secondIndex < aclist.length;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCourseButton(aclist[firstIndex]),
                           
                            if (hasSecond)
                              _buildCourseButton(aclist[secondIndex]),
                              
                          ],
                        );
                        
                      },
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
