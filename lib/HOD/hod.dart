import 'package:biit_directors_dashbooard/HOD/SessionScreen.dart';
import 'package:biit_directors_dashbooard/HOD/assignedCoursesHistoryScreen.dart';
import 'package:biit_directors_dashbooard/HOD/manageDifficulty.dart';
import 'package:flutter/material.dart';
import 'package:biit_directors_dashbooard/HOD/AssignRole.dart';
import 'package:biit_directors_dashbooard/HOD/AssignCourseToFaculty.dart';
import 'package:biit_directors_dashbooard/HOD/ClosGridView.dart';
import 'package:biit_directors_dashbooard/HOD/coursedet.dart';
import 'package:biit_directors_dashbooard/HOD/facultydet.dart';
import 'package:biit_directors_dashbooard/customWidgets.dart';

class HOD extends StatefulWidget {
  const HOD({super.key});

  @override
  State<HOD> createState() => _HODState();
}

class _HODState extends State<HOD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: customAppBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          'HOD Dashboard',
          style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: const Icon(Icons.logout),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png', // Replace with the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height: 20),
                  const Text(
                    'Welcome, Dr. Munir!', // Replace with the actual user's name
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 80),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GridViewScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customButtonColor,
                                  minimumSize: const Size(160, 80),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text(" Manage \nClo's Grid",
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                              const SizedBox(width: 20),
                        SizedBox(
                           height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssignCoursetoFaculty(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customButtonColor,
                              minimumSize: const Size(160, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Assign \nCourses',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                          ],
                        ),
                      
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                               height: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FacultyList(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customButtonColor,
                                  minimumSize: const Size(160, 80),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text('Faculty \nDetails',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                             const SizedBox(width: 20),
                        SizedBox(
                           height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CourseList(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customButtonColor,
                              minimumSize: const Size(160, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Course \nDetails',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                          ],
                        ),
                       
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                               height: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AssignRole(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customButtonColor,
                                  minimumSize: const Size(160, 80),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text('Assign Role',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                             const SizedBox(width: 20),
                        SizedBox(
                           height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ManageDifficulty(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customButtonColor,
                              minimumSize: const Size(160, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Manage \nDifficulty',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                          ],
                        ),

                         
                         const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                               height: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SessionScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customButtonColor,
                                  minimumSize: const Size(160, 80),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: const Text('Manage \nSessions',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                              const SizedBox(width: 20),
                              SizedBox(
                           height: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssignedCoursesHistory(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customButtonColor,
                              minimumSize: const Size(160, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: const Text('Assigned \n Courses \n  History',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                          ],
                        ),
                         
                      
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}