import 'package:biit_directors_dashbooard/HOD/AssignRole.dart';
import 'package:biit_directors_dashbooard/HOD/AssignCourseToFaculty.dart';
import 'package:biit_directors_dashbooard/HOD/ClosGridView.dart';
import 'package:biit_directors_dashbooard/HOD/coursedet.dart';
import 'package:biit_directors_dashbooard/HOD/facultydet.dart';
import 'package:biit_directors_dashbooard/MainPage.dart';
import 'package:flutter/material.dart';

class HOD extends StatefulWidget {
  const HOD({super.key});

  @override
  State<HOD> createState() => _HODState();
}

class _HODState extends State<HOD> {
  @override
  Widget build(BuildContext context) {
     Color customColor = const Color.fromARGB(255, 78, 223, 180);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        elevation: 10,
          title: const Text('HOD Dashboard',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MainPage()));
          },
        ),
      //  backgroundColor: Colors.black.withOpacity(0.9),),
        ),
        body: Stack(children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/HOD.png', // Replace with the path to your background image
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
                  Container(height: 100),
                  const Text(
                    'Welcome, Dr. Munir!', // Replace with the actual user's name
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  const SizedBox(height: 80),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GridViewScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Manage \nGrid View',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssignCoursetoFaculty(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Assign \nCourses',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FacultyList(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Faculty \nDetails',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CourseList(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Course \nDetails',
                              style: TextStyle(color: Colors.black)),
                        ),
                          const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AssignRole(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customColor,
                            minimumSize: const Size(160, 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          child: const Text('Assign Role',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}